# API-Skripte: Kovacs Experience Onboarding-Abrechnung

Drei Skripte, die die Schritte aus `../onboarding-abrechnung-setup.md` über die
Lexoffice- und GoCardless-API ausführen. Keys kommen ausschließlich aus
Umgebungsvariablen und stehen nirgends im Repo.

```bash
export LEXOFFICE_API_KEY="…"        # aus dem Drive-Dokument "API Keys"
export GOCARDLESS_ACCESS_TOKEN="…"  # live_…  aus demselben Dokument
export TAX_MODE=drittland           # oder: 19   (siehe Prüfpunkt 1)
```

| Skript | Was passiert | Mail an Kunde? |
|---|---|---|
| `01_lexoffice_draft.sh` | Kontakt Kovacs Experience AG anlegen (falls nicht vorhanden) und die Onboarding-Rechnung als **Entwurf** anlegen | nein |
| `02_gocardless_check.sh` | Kunde + Mandat lesen, frühestes Einzugsdatum anzeigen | nein |
| `03_gocardless_go.sh payment RE05xx` | Einmal-Einzug 1.500 € (bzw. 1.785 €) anlegen | **ja**, Vorankündigung |
| `03_gocardless_go.sh subscription` | Abo 3.300 €/Monat ab 01.01.2027 anlegen | **ja**, Bestätigung |

Reihenfolge für das „Go“:

1. `01_lexoffice_draft.sh` ausführen, Entwurf in Lexware Office öffnen, prüfen,
   dann dort „Abschließen“ und „Versenden“ klicken (Rechnungsnummer wird vergeben).
2. `02_gocardless_check.sh` ausführen und Mandat-Status `active` bestätigen.
3. `03_gocardless_go.sh payment RE05xx` mit der Rechnungsnummer aus Schritt 1.
4. `03_gocardless_go.sh subscription` (jetzt mit Startdatum 01.01.2027, oder erst im Dezember).
5. Serienrechnung in Lexware Office von Hand anlegen. Die Lexoffice-API kann
   wiederkehrende Vorlagen nur lesen, nicht anlegen.

Voraussetzung in der Claude-Umgebung: `api.lexoffice.io` und `api.gocardless.com`
müssen in der Netzwerk-Policy freigegeben sein. Am 21.09.2026 waren beide gesperrt.
