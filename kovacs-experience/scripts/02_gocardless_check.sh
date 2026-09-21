#!/usr/bin/env bash
# Schritt 2 (nur lesen): GoCardless-Kunde und Mandat prüfen. Löst keine Mail aus.
source "$(dirname "$0")/common.sh"
: "${GOCARDLESS_ACCESS_TOKEN:?GOCARDLESS_ACCESS_TOKEN fehlt}"

API="https://api.gocardless.com"
H=(-H "Authorization: Bearer $GOCARDLESS_ACCESS_TOKEN" -H "GoCardless-Version: 2015-07-06" -H "Content-Type: application/json")

CUST=$(curl -sS "${H[@]}" "$API/customers?email=$CUST_EMAIL")
CID=$(echo "$CUST" | jq -r '.customers[0].id // empty')
[[ -z "$CID" ]] && { echo "Kein GoCardless-Kunde mit $CUST_EMAIL gefunden."; echo "$CUST" | jq .; exit 1; }
echo "$CUST" | jq '.customers[0] | {id, given_name, family_name, company_name, email, created_at}'

MAND=$(curl -sS "${H[@]}" "$API/mandates?customer=$CID")
echo "$MAND" | jq '.mandates[] | {id, status, scheme, created_at, next_possible_charge_date}'
MID=$(echo "$MAND" | jq -r '[.mandates[] | select(.status=="active" or .status=="pending_submission" or .status=="submitted")][0].id // empty')
[[ -z "$MID" ]] && { echo "Kein nutzbares Mandat."; exit 1; }
echo
echo "Mandat für Einzug: $MID"
echo "Einmal-Einzug:  $ONBOARDING_GROSS € ($(cents "$ONBOARDING_GROSS") Cent), Beschreibung: $ONBOARDING_TITLE"
echo "Abo:            $MONTHLY_GROSS € / Monat ab $SUBSCRIPTION_START, Name: $SUBSCRIPTION_NAME"
