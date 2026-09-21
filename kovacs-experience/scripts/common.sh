#!/usr/bin/env bash
# Gemeinsame Werte. Wird von den anderen Skripten per `source` geladen.
set -euo pipefail

need() { command -v "$1" >/dev/null 2>&1 || { echo "Fehlt: $1" >&2; exit 1; }; }
need curl; need jq

: "${TAX_MODE:=drittland}"   # drittland | 19

# Kunde (aus dem PandaDoc-Vertrag, Stand 18.09.2026)
CUST_COMPANY="Kovacs Experience AG"
CUST_FIRST="Gábor"
CUST_LAST="Kovács"
CUST_STREET="Aeschenplatz 2"
CUST_ZIP="4052"
CUST_CITY="Basel"
CUST_COUNTRY="CH"
CUST_EMAIL="gabor@kovacs-experience.ch"
CUST_PHONE="+41 76 394 10 11"
CUST_UID="CHE-151.968.496"

# Beträge in Euro (netto)
ONBOARDING_NET=1500.00
MONTHLY_NET=3300.00

# Bezeichnungen
ONBOARDING_TITLE="Kovacs Experience Onboarding"
SUBSCRIPTION_NAME="YouTube Growth - Kovacs Experience"

# Termine aus § 4 des Vertrags
KICKOFF_DATE="2026-12-02"
SUBSCRIPTION_START="2027-01-01"

case "$TAX_MODE" in
  drittland) TAX_RATE=0;  LEX_TAX_TYPE="thirdPartyCountryService" ;;
  19)        TAX_RATE=19; LEX_TAX_TYPE="net" ;;
  *) echo "TAX_MODE muss 'drittland' oder '19' sein" >&2; exit 1 ;;
esac

gross() { awk -v n="$1" -v r="$TAX_RATE" 'BEGIN{printf "%.2f", n*(1+r/100)}'; }
cents() { awk -v n="$1" 'BEGIN{printf "%d", n*100+0.5}'; }

ONBOARDING_GROSS=$(gross "$ONBOARDING_NET")
MONTHLY_GROSS=$(gross "$MONTHLY_NET")
