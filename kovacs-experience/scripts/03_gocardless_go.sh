#!/usr/bin/env bash
# Das „Go“ für GoCardless. Beide Aktionen lösen sofort E-Mails an den Kunden aus.
#   03_gocardless_go.sh payment RE0515      → Einmal-Einzug Onboarding
#   03_gocardless_go.sh subscription        → Abo ab 01.01.2027
source "$(dirname "$0")/common.sh"
: "${GOCARDLESS_ACCESS_TOKEN:?GOCARDLESS_ACCESS_TOKEN fehlt}"
ACTION="${1:-}"; INVOICE_NO="${2:-}"

API="https://api.gocardless.com"
H=(-H "Authorization: Bearer $GOCARDLESS_ACCESS_TOKEN" -H "GoCardless-Version: 2015-07-06" -H "Content-Type: application/json")

CID=$(curl -sS "${H[@]}" "$API/customers?email=$CUST_EMAIL" | jq -r '.customers[0].id // empty')
MID=$(curl -sS "${H[@]}" "$API/mandates?customer=$CID" | jq -r '[.mandates[] | select(.status=="active" or .status=="pending_submission" or .status=="submitted")][0].id // empty')
[[ -z "$MID" ]] && { echo "Kein nutzbares Mandat für $CUST_EMAIL"; exit 1; }

case "$ACTION" in
  payment)
    [[ -z "$INVOICE_NO" ]] && { echo "Rechnungsnummer angeben: $0 payment RE0515"; exit 1; }
    AMT=$(cents "$ONBOARDING_GROSS")
    echo "Lege Einzug an: $ONBOARDING_GROSS € ($AMT Cent) auf Mandat $MID, Referenz $INVOICE_NO"
    read -r -p "Wirklich anlegen? Der Kunde bekommt sofort eine Vorankündigung. [ja/nein] " ok
    [[ "$ok" == "ja" ]] || { echo "Abgebrochen."; exit 0; }
    BODY=$(jq -n --argjson amt "$AMT" --arg d "$ONBOARDING_TITLE" --arg inv "$INVOICE_NO" --arg m "$MID" \
      '{payments:{amount:$amt,currency:"EUR",description:$d,metadata:{invoice:$inv},links:{mandate:$m}}}')
    curl -sS "${H[@]}" -H "Idempotency-Key: kovacs-onboarding-$INVOICE_NO" -X POST "$API/payments" -d "$BODY" | jq .
    ;;
  subscription)
    AMT=$(cents "$MONTHLY_GROSS")
    echo "Lege Abo an: $MONTHLY_GROSS € ($AMT Cent) monatlich zum 1., Start $SUBSCRIPTION_START, Mandat $MID"
    read -r -p "Wirklich anlegen? Der Kunde bekommt sofort eine Bestätigung. [ja/nein] " ok
    [[ "$ok" == "ja" ]] || { echo "Abgebrochen."; exit 0; }
    BODY=$(jq -n --argjson amt "$AMT" --arg n "$SUBSCRIPTION_NAME" --arg s "$SUBSCRIPTION_START" --arg m "$MID" \
      '{subscriptions:{amount:$amt,currency:"EUR",name:$n,interval_unit:"monthly",day_of_month:1,start_date:$s,
        metadata:{contract:"YouTube Content Dienstleistungsvertrag 18.09.2026"},links:{mandate:$m}}}')
    curl -sS "${H[@]}" -H "Idempotency-Key: kovacs-subscription-$SUBSCRIPTION_START" -X POST "$API/subscriptions" -d "$BODY" | jq .
    ;;
  *) echo "Aufruf: $0 payment RE05xx | $0 subscription"; exit 1 ;;
esac
