# Schweizer Kunden und GoCardless: Stand, Ursache, Lösungen

Stand: 28.09.2026

## Was passiert ist

| Kunde | Bank-Land | Verlauf |
|---|---|---|
| Kovacs Experience AG (Gábor Kovács) | CH | Rechnung RE0518 (Onboarding 1.500 €) am 22.09.2026 versendet. GoCardless-Einzug am 23./24.09.2026 fehlgeschlagen. Keine Antwort von Gábor bisher. Mandat vom 18.09.2026 laut Postfach noch nicht abgebrochen. |
| BeeBase GmbH (Pascal Borner) | CH | Einzüge fehlgeschlagen am 31.03., 06.04., 08.04. und 04.05.2026. Neu-Registrierung hat nichts gebracht. Zahlt seither per Überweisung auf Rechnung. |
| AJL Consulting (Simon Lehmann) | CH | Einzüge fehlgeschlagen am 15.04. und 13.05.2026, jeweils mit automatisch abgebrochenem Mandat. Simon hat ein EUR-Konto mit Deckung, seine Bank „kann nichts machen“. Zahlt seither manuell. |

Zum Vergleich: alle deutschen Kunden (Skalar, Klemmer, Croset, BSK, Ibency usw.) laufen über GoCardless problemlos.

## Was GoCardless dazu gesagt hat

Zwei Tickets, beide ohne Lösung geschlossen:

- **Ticket 4261191 (April 2026, „Failed Direct Debit – Swiss Customer“)**: Rückgabecodes der Kundenbanken waren
  **MS03** (Grund aus regulatorischen Gründen nicht genannt) und **DNOR** (Bank des Kunden hat die Zahlung
  abgelehnt). GoCardless: Ablehnung kommt von der Bank des Kunden, GoCardless kann nichts tun, Konto muss in
  EUR geführt sein, Kunde soll seine Bank fragen, danach erneut einziehen.
- **Ticket 4312601 (Mai 2026, „Zahlungen aus der Schweiz“)**: identische Antwort. „Leider können wir
  unsererseits in solchen Fällen nichts Weiteres unternehmen.“

Eine weitere Anfrage an den GoCardless-Support bringt nichts Neues. Das Problem liegt nicht bei GoCardless und
nicht bei der Anmeldung der Kunden.

## Ursache

Die Schweiz gehört zum SEPA-Raum, aber die SEPA-Lastschrift (Core) wird auf Schuldnerseite nur von wenigen
Schweizer Banken unterstützt, und dort nur auf Euro-Konten und erst nach ausdrücklicher Freischaltung durch den
Kontoinhaber (Belastungsermächtigung oder Zulassung des Gläubigers bei der Bank). Ohne diese Freischaltung
lehnt die Bank jede Lastschrift ab, und zwar genau mit den Codes MS03 und DNOR.

- Unterstützen SEPA-Lastschrift nach Freischaltung: UBS, PostFinance, Raiffeisen, einige Kantonalbanken.
- Unterstützen sie nicht: u. a. Bank Cler, Migros Bank, Zürcher Kantonalbank.

Das erklärt auch Simons Fall: EUR-Konto und Deckung waren da, aber die Freischaltung für Lastschriften fehlte
oder seine Bank bietet sie nicht an. Ein erneuter Einzug ohne diese Freischaltung schlägt wieder fehl und
erzeugt jedes Mal eine Fehlermail an den Kunden.

Quellen: [UBS SEPA](https://www.ubs.com/ch/de/services/payments/international-payments/sepa.html),
[UBS Lastschrift Rechnungen bezahlen](https://www.ubs.com/ch/de/services/payments/pay-invoices/direct-debit.html),
[Raiffeisen SEPA-Firmenlastschrift](https://www.raiffeisen.ch/rch/de/unternehmen/zahlungsverkehr/rechnungen-bezahlen/sepa-firmenlastschrift.html),
[moneyland.ch Lastschrift Schweiz](https://www.moneyland.ch/en/direct-debits-switzerland-faq),
[SEPA-Rückgabecodes](https://narvi.com/blog/sepa-codes-explained),
[GoCardless Bank account location requirements](https://support.gocardless.com/hc/en-gb/articles/360010169733-Bank-account-location-requirements).

## Lösung für Kovacs Experience (jetzt)

Empfehlung: **Überweisung plus Dauerauftrag auf Kundenseite**, kein GoCardless.

1. Onboarding-Rechnung RE0518 (1.500 €) per Überweisung, Bankverbindung steht auf der Rechnung.
2. Für die monatliche Vergütung richtet Gábor bei seiner Bank einen Dauerauftrag über 3.300 € zum 1. des
   Monats ein, erste Ausführung 01.01.2027. Die Serienrechnung in Lexware Office läuft wie geplant.
3. Zahlungsweise per E-Mail als Nachtrag zum Vertrag festhalten (§ 3 Abs. 1 nennt GoCardless).
4. In GoCardless: fehlgeschlagene Zahlung nicht erneut anstoßen, Success+ nicht aktivieren. Mandat kann
   bestehen bleiben, falls Gábor doch die Freischaltung bei seiner Bank macht.

Warum das die beste Lösung ist: null Ausfallrisiko, keine Gebühren, keine automatischen Fehlermails an den
Kunden, der Kunde behält die Kontrolle. Der einzige Nachteil ist, dass der Zahlungseingang in Lexware manuell
zugeordnet wird, was Friederike ohnehin wöchentlich macht.

Alternative, falls Gábor Lastschrift bevorzugt: Er lässt bei seiner Bank SEPA-Lastschriften auf dem EUR-Konto
freischalten und GoCardless als Gläubiger zu. Dafür braucht die Bank die Gläubiger-ID von GoCardless (im
GoCardless-Dashboard unter Einstellungen / Mandat einsehbar) und den Namen auf dem Kontoauszug (OnStage). Erst
danach erneut einziehen.

Die E-Mail an Gábor liegt als Entwurf in Gmail (Antwort auf die Rechnungsmail RE0518).

## Regel für alle künftigen Schweizer Kunden

1. **Vertragsvorlage**: Für Kunden mit Bankkonto in der Schweiz § 3 Abs. 1 ändern in „Die Zahlung erfolgt
   jeweils zum 1. eines Monats per Überweisung (Dauerauftrag)“. Kein GoCardless-Link in der Willkommensmail.
2. **Onboarding-Mail**: Bitte um Dauerauftrag mit Betrag, Ausführungstag und Verwendungszweck, plus
   Bankverbindung. Die erste Rechnung (Onboarding) per Überweisung mit Zahlungsziel 7 Tage.
3. **Nur wenn der Kunde ausdrücklich Lastschrift will**: vorher abfragen, welche Bank, ob EUR-Konto, und ob die
   Bank SEPA-Lastschriften freischaltet. Erst nach Bestätigung der Bank den GoCardless-Link schicken.
4. **Bestand**: BeeBase und AJL laufen bereits auf Überweisung. Für die Zukunft dort ebenfalls Dauerauftrag
   anregen, damit die Zahlungen pünktlich zum 1. kommen.

## Weitere Optionen, bewusst nicht empfohlen

- **Kartenzahlung (Stripe)**: funktioniert zuverlässig mit Schweizer Firmenkarten, kostet aber rund 1,5 bis
  3 % plus Fixgebühr. Bei 3.300 € im Monat sind das etwa 50 bis 100 € pro Monat und Kunde. Nur sinnvoll, wenn ein
  Kunde partout keinen Dauerauftrag einrichten will.
- **GoCardless erneut versuchen ohne Bankfreischaltung**: erzeugt nur weitere Fehlermails beim Kunden.
- **Schweizer LSV+ / CH-DD**: reines CHF-Verfahren, wird von SIX ohnehin eingestellt und braucht ein Schweizer
  Bankkonto.

## Vorlage: Text des Kunden an seine Bank (nur wenn er Lastschrift will)

Die Bank nimmt eine Freischaltung nur vom Kontoinhaber an. Wir schreiben die Bank nie selbst an. Der Kunde
braucht dafür zwei Werte aus dem GoCardless-Dashboard (beim Kunden unter dem Mandat): die
Gläubiger-Identifikationsnummer, unter der GoCardless einzieht, und die Mandatsreferenz.

```
Betreff: Freischaltung SEPA-Lastschrift auf meinem Euro-Konto

Guten Tag

Ich möchte auf meinem Euro-Konto [IBAN CH…] SEPA-Basislastschriften (SEPA Core Direct Debit) zulassen und den
folgenden Zahlungsempfänger für Belastungen freigeben:

Zahlungsempfänger: OnStage / Noah Schering, eingezogen über GoCardless SAS, Paris
Gläubiger-Identifikationsnummer: [aus dem GoCardless-Dashboard]
Mandatsreferenz: [aus dem GoCardless-Dashboard]
Betrag: einmalig EUR [Onboarding], danach monatlich EUR [Monatsbetrag] jeweils zum 1. des Monats

Am [Datum] wurde eine Lastschrift dieses Empfängers über EUR [Betrag] zurückgewiesen. Bitte teilen Sie mir mit,
was für die Freischaltung nötig ist (Formular, Ermächtigung im E-Banking) und bestätigen Sie mir, sobald
Lastschriften dieses Empfängers ausgeführt werden.

Freundliche Grüsse
[Name]
[Firma]
```

Erst nach der Bestätigung der Bank erneut einziehen. Bei Bank Cler, Migros Bank und ZKB gar nicht erst
versuchen, dort bleibt es bei Überweisung und Dauerauftrag.
