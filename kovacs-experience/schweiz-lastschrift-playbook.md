# Schweizer Kunden und GoCardless: Stand, Ursache, Lösungen

Stand: 28.09.2026. Entscheidung: Wir bleiben bei der Lastschrift (Planbarkeit, kein Hinterherlaufen),
holen aber vor jedem Einzug die Freischaltung bei der Bank des Kunden ein.

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

Die Schweiz gehört zum SEPA-Raum, und GoCardless zieht auch von CH-IBANs ein. GoCardless nutzt aber
ausschließlich die **SEPA-Basislastschrift (Core)**, nicht die Firmenlastschrift (B2B). Auf Schuldnerseite
erlauben Schweizer Banken SEPA-Lastschriften in der Regel nicht von sich aus: Sie brauchen ein Euro-Konto und
eine ausdrückliche Anmeldung des Kontoinhabers zum SEPA-Lastschriftverfahren, meist mit Hinterlegung des
Mandats oder einer Belastungsermächtigung bei der Bank. Ohne diese Freischaltung lehnt die Bank jede
Lastschrift ab, und zwar genau mit den Codes MS03 und DNOR. Einige Banken bieten das Verfahren für Zahler gar
nicht an.

Das erklärt auch Simons Fall: EUR-Konto und Deckung waren da, aber die Anmeldung zum Lastschriftverfahren
fehlte oder seine Bank bietet sie nicht an. Ein erneuter Einzug ohne diese Freischaltung schlägt wieder fehl und
erzeugt jedes Mal eine Fehlermail an den Kunden.

## Welche Bank kann was (Stand der Websites, September 2026)

| Bank | SEPA-Basislastschrift für Zahler | Was der Kunde tun muss |
|---|---|---|
| UBS, inkl. ehemalige Credit Suisse | ja | Kundenberater kontaktieren, Anmeldeformular zum SEPA-Lastschriftverfahren unterschreiben, unterschriebenes Mandat bei der Bank hinterlegen. Euro-Konto empfohlen. |
| PostFinance | ja, auf dem EUR-Konto | EUR-Konto mit E-Finance, gültiges Core-Mandat. Für Privat- und Geschäftskunden. |
| Raiffeisen | ja, nach Anmeldung | Anmeldung zum SEPA-Basislastschriftverfahren bei der eigenen Raiffeisenbank. Achtung: Raiffeisen bewirbt für Firmen die Firmenlastschrift (B2B), die GoCardless nicht nutzt. Ausdrücklich Basislastschrift verlangen. |
| BCGE (Genf) | ja | Konto in CHF oder EUR. |
| Bank Cler, Migros Bank, Zürcher Kantonalbank | nein | Kein SEPA-Lastschriftverfahren für Zahler. Direkt Plan B. |
| Basler Kantonalbank und andere Kantonalbanken | unklar | Mit dem Banktext unten anfragen. Die Antwort entscheidet zwischen Plan A und Plan B. |

Quellen: [UBS SEPA-Zahlungen](https://www.ubs.com/ch/de/services/payments/international-payments/sepa.html),
[UBS Lastschrift Rechnungen bezahlen](https://www.ubs.com/ch/de/services/payments/pay-invoices/direct-debit.html),
[Credit Suisse/UBS: SEPA-Lastschriftverfahren für Zahlungspflichtige (PDF)](https://www.ubs.com/microsites/credit-suisse/de/private-clients/accounts-and-cards/all-services/_jcr_content/mainpar/toplevelgrid/col1/accordion/accordionsplit_1392517660/teaser_105926151/linklist/link.1208047831.file/PS9jb250ZW50L2RhbS9hc3NldHMvbWljcm9zaXRlcy9jcmVkaXQtc3Vpc3NlL2RvY3VtZW50cy9wcml2YXRlLWNsaWVudHMvc2VwYS1kaXJlY3QtZGViaXQtZm9yLXBheWVycy1kZS5wZGY=/sepa-direct-debit-for-payers-de.pdf),
[PostFinance SEPA Direct Debit Privatkunden](https://www.postfinance.ch/en/private/paying-saving/international-payments/sepa-direct-debit-scheme.html),
[PostFinance SEPA](https://www.postfinance.ch/en/private/paying-saving/international-payments/sepa-debit-direct.html),
[Raiffeisen SEPA-Firmenlastschrift](https://www.raiffeisen.ch/rch/de/unternehmen/zahlungsverkehr/rechnungen-bezahlen/sepa-firmenlastschrift.html),
[BCGE SEPA Direct Debit](https://www.bcge.ch/de/sepa-direct-debit),
[moneyland.ch Lastschrift Schweiz](https://www.moneyland.ch/en/direct-debits-switzerland-faq),
[GoCardless: Länder, aus denen eingezogen werden kann](https://support.gocardless.com/hc/en-gb/articles/17133306652572-Countries-you-can-collect-from),
[GoCardless SEPA Direct Debit (nur Core)](https://support.gocardless.com/hc/en-us/articles/27142609814812-SEPA-Direct-Debit),
[GoCardless: Mandat als PDF exportieren](https://support.gocardless.com/hc/en-us/articles/115002590349-Exporting-mandate-forms),
[SEPA-Rückgabecodes](https://narvi.com/blog/sepa-codes-explained).

## Plan A: Lastschrift mit Bankfreischaltung (Standard für Schweizer Kunden)

Ablauf für Noah:

1. **Mandat exportieren.** GoCardless-Dashboard → Kunde → Bankkonto → Mandat → drei Punkte oben rechts →
   „Export mandate“, Sprache Deutsch. Auf dem PDF stehen die Gläubiger-Identifikationsnummer (Creditor ID), die
   Mandatsreferenz und das Mandatsdatum. Diese drei Werte in den Banktext eintragen, PDF an die Mail hängen.
2. **Mail an den Kunden** (Entwurf liegt in Gmail): Bank abfragen, Banktext zum Weiterleiten mitgeben, die
   Onboarding-Rechnung parallel per Überweisung, damit nichts wartet.
3. **Bank bestätigt Freischaltung** → im Dashboard die fehlgeschlagene Zahlung erneut anstoßen („Retry“) oder
   neue Zahlung anlegen. Erst dann das Abo mit Start 01.01.2027 anlegen.
4. **Bank sagt nein oder meldet sich nicht innerhalb von 10 Tagen** → Plan B.
5. **Success+ bleibt aus.** Automatische Wiederholungen ohne Freischaltung erzeugen nur Fehlermails beim Kunden.

Ehrlicher Hinweis zur Sicherheit: Die SEPA-Basislastschrift gibt dem Kunden acht Wochen Widerspruchsrecht ohne
Angabe von Gründen. Die Lastschrift bringt Planbarkeit und erspart das Nachfassen, sie ist keine Zahlungsgarantie.

## Vorlage: Banktext für den Kunden (Plan A)

Der Kunde leitet diesen Text an seinen Kundenberater oder über das E-Banking-Postfach weiter. Die eckigen
Klammern füllt Noah vor dem Versand aus, die IBAN trägt der Kunde ein.

```
Betreff: Freischaltung SEPA-Basislastschrift (SEPA Core Direct Debit) auf meinem Euro-Konto

Guten Tag

Bitte schalten Sie auf meinem Euro-Konto IBAN [CH…] das SEPA-Basislastschriftverfahren (SEPA Core Direct
Debit) frei und registrieren Sie den folgenden Zahlungsempfänger für wiederkehrende Belastungen:

Zahlungsempfänger (Name auf dem Kontoauszug): OnStage / Noah Schering, Nürnberg (DE)
Einzug über den Zahlungsdienstleister: GoCardless SAS, 7 rue de Madrid, 75008 Paris, Frankreich
Gläubiger-Identifikationsnummer (Creditor ID): [aus dem Mandats-PDF]
Mandatsreferenz: [aus dem Mandats-PDF]
Mandat erteilt am: 18.09.2026 (elektronisch, Kopie im Anhang)
Art: wiederkehrende Lastschrift, monatlich zum 1., erstmals 01.01.2027
Beträge: einmalig EUR 1.500,00 (Onboarding), danach EUR 3.300,00 pro Monat
Falls Sie eine Limite pro Belastung setzen: EUR 3.500,00

Hintergrund: Am 23./24.09.2026 wurde eine Lastschrift dieses Empfängers über EUR 1.500,00 zurückgewiesen.
Bitte nennen Sie mir den Rückgabegrund (Rückgabecode, z. B. MS03 oder DNOR) und sagen Sie mir, ob für die
Freischaltung ein Formular Ihrer Bank nötig ist (Anmeldung SEPA-Lastschriftverfahren oder
Belastungsermächtigung). Ich reiche es umgehend unterschrieben ein.

Bitte bestätigen Sie mir schriftlich, sobald Lastschriften dieses Empfängers auf dem Konto ausgeführt werden.
Falls Ihre Bank das SEPA-Basislastschriftverfahren für Zahlungspflichtige nicht anbietet, bitte ich ebenfalls
um eine kurze Rückmeldung.

Freundliche Grüsse
Gábor Kovács
Kovacs Experience AG, Aeschenplatz 2, 4052 Basel
```

Für andere Kunden: Name, Beträge, Daten und Adresse austauschen, Rest bleibt.

## Plan B: Euro-Konto bei Wise Business oder Revolut Business

Wenn die Hausbank keine SEPA-Lastschriften zulässt, der Kunde aber bei der Lastschrift bleiben will: Wise
Business und Revolut Business führen Euro-Konten mit EUR-IBAN, von denen SEPA-Lastschriften in EUR abgebucht
werden können. Der Kunde eröffnet das Konto, richtet von seiner Hausbank einen Dauerauftrag zur Deckung ein
(z. B. 3.400 € zum 25. des Monats) und registriert sich mit der neuen IBAN erneut über den GoCardless-Link.
Aufwand beim Kunden etwa eine Stunde, danach läuft es wie bei deutschen Kunden.

Quellen: [Wise zu Revolut Business und Direct Debit](https://wise.com/gb/blog/revolut-business-direct-debit),
[Revolut Business vs Wise Business](https://www.revolut.com/en-PT/business/comparison/revolut-business-vs-wise-business-eea/).

## Plan C: Überweisung plus Dauerauftrag auf Kundenseite

Wenn der Kunde weder Freischaltung noch Zweitkonto will: Onboarding per Überweisung, monatlich Dauerauftrag
über den Monatsbetrag zum 1., Serienrechnung in Lexware Office wie geplant, Zahlungsweise per E-Mail als
Vertragsergänzung festhalten. So laufen BeeBase und AJL heute. Nachteil: kein Zugriff bei ausbleibender Zahlung,
Zahlungseingang wird in Lexware manuell zugeordnet.

## Regel für alle künftigen Schweizer Kunden

1. **Vor dem GoCardless-Link** abfragen: Welche Bank? Gibt es ein Euro-Konto? Dann Banktext mit den
   Angaben von GoCardless mitschicken und um Freischaltung bitten. Erst nach Bestätigung der Bank den
   GoCardless-Link schicken und einziehen.
2. **Bank Cler, Migros Bank, ZKB**: gar nicht erst versuchen, direkt Plan B oder C anbieten.
3. **Vertragsvorlage** für Schweizer Kunden: § 3 Abs. 1 ergänzen um „Voraussetzung ist die Freischaltung des
   SEPA-Lastschriftverfahrens durch die Bank des Kunden. Bis dahin oder falls die Bank das Verfahren nicht
   anbietet, erfolgt die Zahlung per Überweisung zum 1. des Monats.“
4. **Onboarding-Rechnung** bei Schweizer Kunden immer per Überweisung mit Zahlungsziel 7 Tage, damit der Start
   nicht an der Bankfreischaltung hängt.
5. **Bestand**: BeeBase und AJL mit demselben Banktext erneut ansprechen, ob ihre Bank die Freischaltung anbietet.

## Bewusst nicht empfohlen

- **Kartenzahlung (Stripe)**: zuverlässig, aber rund 1,5 bis 3 % plus Fixgebühr, bei 3.300 € im Monat etwa 50
  bis 100 € pro Monat und Kunde.
- **GoCardless erneut versuchen ohne Bankfreischaltung**: erzeugt nur weitere Fehlermails beim Kunden.
- **Schweizer LSV+ / CH-DD**: reines CHF-Verfahren, wird von SIX eingestellt und braucht ein Schweizer Bankkonto.
- **Die Bank selbst anschreiben**: Die Bank spricht nur mit dem Kontoinhaber. Deshalb der Banktext für den Kunden.
