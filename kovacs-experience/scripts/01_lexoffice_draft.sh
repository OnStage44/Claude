#!/usr/bin/env bash
# Schritt 1: Kontakt anlegen (falls nötig) und Onboarding-Rechnung als ENTWURF anlegen.
# Es wird nichts versendet. Abschließen und Versenden passiert in Lexware Office.
source "$(dirname "$0")/common.sh"
: "${LEXOFFICE_API_KEY:?LEXOFFICE_API_KEY fehlt}"

API="https://api.lexoffice.io/v1"
H=(-H "Authorization: Bearer $LEXOFFICE_API_KEY" -H "Accept: application/json" -H "Content-Type: application/json")

echo "Steuer-Modus: $TAX_MODE (Satz $TAX_RATE %, Lexoffice taxType $LEX_TAX_TYPE)"
echo "Onboarding: $ONBOARDING_NET € netto → $ONBOARDING_GROSS € brutto"

# 1) Kontakt suchen
CONTACT_ID=$(curl -sS "${H[@]}" "$API/contacts?email=$CUST_EMAIL" \
  | jq -r --arg n "$CUST_COMPANY" '.content[]? | select(.company.name==$n) | .id' | head -n1)

if [[ -z "$CONTACT_ID" ]]; then
  echo "Kontakt nicht gefunden, lege an …"
  BODY=$(jq -n --arg co "$CUST_COMPANY" --arg fn "$CUST_FIRST" --arg ln "$CUST_LAST" \
    --arg st "$CUST_STREET" --arg zip "$CUST_ZIP" --arg city "$CUST_CITY" --arg cc "$CUST_COUNTRY" \
    --arg em "$CUST_EMAIL" --arg ph "$CUST_PHONE" --arg uid "$CUST_UID" '
  { version: 0,
    roles: { customer: {} },
    company: { name: $co, vatRegistrationId: $uid,
               contactPersons: [ { firstName: $fn, lastName: $ln, primary: true,
                                   emailAddress: $em, phoneNumber: $ph } ] },
    addresses: { billing: [ { street: $st, zip: $zip, city: $city, countryCode: $cc } ] },
    emailAddresses: { business: [ $em ] },
    phoneNumbers: { business: [ $ph ] },
    note: "YouTube Content Dienstleistungsvertrag vom 18.09.2026, Zahlung per GoCardless"
  }')
  CONTACT_ID=$(curl -sS "${H[@]}" -X POST "$API/contacts" -d "$BODY" | jq -r '.id')
  echo "Kontakt angelegt: $CONTACT_ID"
else
  echo "Kontakt vorhanden: $CONTACT_ID"
fi

# 2) Rechnungsentwurf (finalize=false → Entwurf, keine Nummer, keine Mail)
TODAY=$(date +%Y-%m-%dT00:00:00.000+02:00)
INV=$(jq -n --arg cid "$CONTACT_ID" --arg date "$TODAY" --arg title "$ONBOARDING_TITLE" \
  --argjson net "$ONBOARDING_NET" --argjson rate "$TAX_RATE" --arg taxType "$LEX_TAX_TYPE" \
  --arg kickoff "$KICKOFF_DATE" '
{ voucherDate: $date,
  address: { contactId: $cid },
  lineItems: [
    { type: "custom",
      name: $title,
      description: ("Einmalige Onboarding-Gebühr gemäß § 3 Abs. 2 des YouTube Content Dienstleistungsvertrags vom 18.09.2026. Umfasst die dreiwöchige Onboarding-Phase (Strategie, Setup, Zugänge, Unterlagen) ab Kick-Off am 02.12.2026."),
      quantity: 1,
      unitName: "Pauschale",
      unitPrice: { currency: "EUR", netAmount: $net, taxRatePercentage: $rate } }
  ],
  totalPrice: { currency: "EUR" },
  taxConditions: { taxType: $taxType },
  shippingConditions: { shippingDate: $date, shippingType: "service" },
  paymentConditions: { paymentTermLabel: "Zahlung per SEPA-Lastschrift über GoCardless. Der Betrag wird automatisch eingezogen, es ist keine Überweisung nötig.",
                       paymentTermDuration: 0 },
  title: $title,
  introduction: "vielen Dank für das Vertrauen. Wie vereinbart stellen wir die einmalige Onboarding-Gebühr in Rechnung.",
  remark: "Wir freuen uns auf den Kick-Off am 02.12.2026."
}')
RES=$(curl -sS "${H[@]}" -X POST "$API/invoices?finalize=false" -d "$INV")
echo "$RES" | jq .
ID=$(echo "$RES" | jq -r '.id // empty')
[[ -n "$ID" ]] && echo "Entwurf angelegt. Öffnen: https://app.lexoffice.de/permalink/invoices/view/$ID"
