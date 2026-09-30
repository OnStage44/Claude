---
name: podcast-leads
description: Generiert weitere Podcast-Gast-Leads für OnStage-Kunden nach dem Apollo-Verfahren, mit dem im August/September 2026 die Listen für Sonia (Recruiting Sonia) und BeeBase gebaut wurden. Nutzen, wenn jemand sagt "mach mir 200 weitere Leads für BeeBase", "nächster Sonia-Batch", "Podcast-Leads für <Kunde>", "Leads anreichern", "Podcast-Gäste finden". Funktioniert für Sonia und BeeBase sofort und für neue ICP-Podcast-Kunden nach Schritt 0.
---

# Podcast-Leads für OnStage-Kunden

Ziel: Der Kunde bekommt eine Longlist potenzieller Podcast-Gäste, die gleichzeitig seine
Wunschkunden sind (ICP-Podcast als Akquise-Kanal). Der Kunde qualifiziert die Liste, wir
reichern die qualifizierten Leads mit E-Mail an, Stephen lädt sie in Instantly.

Benötigte Connectoren: **Apollo.io** (Suche und Anreicherung), **Google Drive** (Sheets),
**Slack** (Übergabe). Ohne Apollo geht nichts, dann abbrechen und Bescheid geben.

## Schritt 0: Auftrag klären

Aus der Anfrage ableiten, sonst nachfragen:

1. **Kunde**: Sonia oder BeeBase (Profile unten) oder ein neuer Kunde. Bei einem neuen
   Kunden zuerst das Dokument "Zielgruppenverständnis <Kunde>" in Google Drive lesen und
   daraus Standort, Firmengröße, Branchen und Entscheider-Titel ableiten. Das Profil dann
   analog zu den beiden unten aufschreiben und vor dem Start kurz bestätigen lassen.
2. **Anzahl**: Wie viele neue Leads. Standard, wenn nichts gesagt wird: 300.
3. **Stufe**: nur Longlist zur Qualifizierung (kostet keine Credits) oder direkt inkl.
   E-Mail-Anreicherung (1 Apollo-Credit pro Lead). Standard: Longlist zuerst, Anreicherung
   erst, wenn der Kunde oder Noah die Stichprobe freigegeben hat. So lief es bei beiden
   Kunden: erst 20 Leads zur Prüfung, dann 300 angereichert.

## Kundenprofile (Apollo-Filter, geprüft am 30.09.2026)

### Sonia (Recruiting Sonia, Sales Hiring für B2B SaaS und Tech)

Quelle: Zielgruppenverständnis Sonia, Feedback von Sonia auf die erste 20er-Liste.

| Filter | Wert für `apollo_mixed_people_api_search` |
|---|---|
| `person_locations` | eine Stadt pro Suchlauf, z.B. `["Berlin, Germany"]`, `["Wien, Austria"]`, `["Zürich, Switzerland"]` |
| `person_titles` | `["CEO", "Founder", "Co-Founder", "Geschäftsführer", "Managing Director", "Chief Revenue Officer"]` |
| `organization_num_employees_ranges` | `["21,50", "51,100", "101,200", "201,500"]` |
| `q_organization_keyword_tags` | `["SaaS", "B2B software"]` |
| `per_page` | `100` |

Zweite Zielgruppe laut Zielgruppenverständnis, bisher nicht abgesucht: VP Sales und Head of
Sales mit Teamverantwortung. Für neue Batches jenseits der Gründer ist das der nächste Hebel:
`person_titles` auf `["VP Sales", "Head of Sales", "Chief Sales Officer"]` setzen, sonst gleiche Filter.

**Was Sonia aussortiert** (aus ihrem Feedback, vorab rausfiltern):
- Softwareentwicklung oder IT-Dienstleistung ohne eigenes SaaS-Produkt (ConSol, NetDescribe,
  TriniDat, upsidecode): "die hiren Developer, keine Sales-Profile".
- Agenturen, auch Medien- oder Kreativagenturen (la red).
- Firmen, mit denen sie gerade arbeitet oder die Wettbewerber ihrer Kunden sind (Taxdoo wegen
  Pennylane). Das kann nur sie beurteilen, deshalb bleibt die Kommentarspalte.

**Stand der Abdeckung**: 83 Batches, 1.000 Leads, Stadt für Stadt jeweils Seite 1 der
Apollo-Suche, teils Seite 2 (Berlin, München, Villach). Abgesucht sind unter anderem Berlin,
München, Wien, Zürich, Nürnberg, Hannover, Dresden, Bremen, Rostock, Potsdam, Osnabrück, Graz,
Basel, Lausanne, Genf, Villach, Mannheim, Ludwigshafen, Saarbrücken, Ravensburg, Bregenz. Für
neue Gründer-Leads deshalb bei den großen Städten auf Seite 2 und 3 gehen (`page`), oder
statt Städten das ganze Land absuchen (`["Germany"]`) und gegen die Masterliste deduplizieren.

### BeeBase (IT-Dienstleistungen für Schweizer KMU)

Quelle: Zielgruppenverständnis BeeBase, Kopfzeile der Lead-Sheets, Feedback von Pascal auf
die erste 20er-Liste.

| Filter | Wert für `apollo_mixed_people_api_search` |
|---|---|
| `person_locations` | `["Switzerland"]` |
| `organization_locations` | `["Switzerland"]` |
| `person_titles` | `["Geschäftsführer", "CEO", "COO", "Head of Operations", "Betriebsleiter", "IT-Leiter", "Leiter IT"]` |
| `organization_num_employees_ranges` | `["21,50", "51,100", "101,200"]` |
| `q_organization_keyword_tags` | pro Suchlauf eine Branche: `["energy"]`, `["real estate"]`, `["construction"]`, `["facility management"]`, `["cleaning"]` |
| `per_page` | `100` |

Diese Suche liefert rund 3.600 Treffer (Stand 30.09.2026), die ersten 300 sind angereichert.
Neue Batches: mit `page` weiterblättern und pro Branche gleichmäßig ziehen, damit die Liste
nicht nur aus Energieversorgern besteht.

**Was Pascal aussortiert**:
- Zu groß, "zu viele MA": Apollo-Firmengröße ist unscharf, bei bekannten Konzern-Töchtern oder
  Gruppen (FARO, Pollux) lieber weglassen.
- Firmen, die selbst IT anbieten oder eine eigene IT-Abteilung haben (Gemdat, IT-Beratungen,
  Immobilien-Software-Häuser).
- Nur ein Kontakt pro Firma (Walde Immobilien war doppelt drin).
- Deutschschweiz bevorzugen, Romandie und Tessin nur wenn der Kunde es will.

## Schritt 1: Bestehende Leads laden und deduplizieren

Vor jeder Suche die bisherigen Listen aus Google Drive lesen und einen Dedupe-Schlüssel
bilden: Firmenname normalisiert (klein, ohne "AG", "GmbH", "SA", Satzzeichen) plus Vorname.
Bei BeeBase zusätzlich E-Mail und LinkedIn-URL. Ein Lead, der schon in einer Liste steht,
kommt nicht noch einmal in einen Batch.

Sonia (Masterliste = MIT_EMAIL + NOCH_ANREICHERN, zusammen die 1.000 Leads aus 83 Batches):
- Podcast_Leads_Sonia_MIT_EMAIL, Drive-ID `1bvBkeFkYcDF_viRbXDMkAtMykfJpd5KhAB_tsc7-xCA`
- Podcast_Leads_Sonia_NOCH_ANREICHERN, Drive-ID `1jTgx_DZdlonwwnwhOS_8IIzNQXIjL6GM3-gavtchrVE`
- Podcast_Leads_Sonia (erste 20 mit Sonias Feedback), Drive-ID `1GSG1uwme5xQdVZ3U0jPi9-vNAT1_gWon2Cj4OCiHiIg`

BeeBase:
- BeeBase_300_enriched_final, Drive-ID `1YuTay1plHiaXewGoARtihLlvolV-8mscWZSN4bpby0k`
- BeeBase_Podcast_Leads (erste 20 mit Pascals Feedback), Drive-ID `1XLjeXtD918k1khSBnoXlXB4PO3NNFJ2LetrTQgAvCrY`

Neue Sheets, die dieser Skill anlegt, gehören in dieselbe Namenslogik, damit sie beim
nächsten Lauf über die Drive-Suche `title contains 'Podcast_Leads_Sonia'` bzw.
`title contains 'BeeBase'` gefunden werden.

**Blacklist**: Der Kunde soll Bestandskunden und No-Go-Firmen nennen (Noah, Slack 20.09.2026).
Wenn im Kickoff- oder Onboarding-Dokument des Kunden eine Blacklist steht, diese Firmen
ebenfalls aussortieren. Gibt es keine, im Ergebnis darauf hinweisen, damit Michelle sie vor
dem Instantly-Upload einholt.

## Schritt 2: Apollo-Suche

`apollo_mixed_people_api_search` mit den Filtern des Kunden, `per_page: 100`, `page`
hochzählen. Die Suche kostet keine Credits. Nachnamen sind in der Suche maskiert, das ist
normal; die Apollo-`id` jedes Treffers merken, sie wird für die Anreicherung gebraucht.

Pro Treffer festhalten: Apollo-ID, Vorname, maskierter Nachname, Titel, Firma, Ort (falls
geliefert), `has_email`. Treffer ohne `has_email: true` nur mitnehmen, wenn die Longlist
ohnehin nicht angereichert wird.

So lange weitersuchen (nächste Seite, nächste Stadt oder Branche), bis nach Dedupe und
Vorfilter (Schritt 3) die gewünschte Anzahl erreicht ist. Bei Sonia im Sheet-Kopf notieren,
welche Städte und Seiten der Batch abdeckt, so wie bisher ("Batch 84: Hamburg S.2, Köln S.2 …").

## Schritt 3: Vorfilter

Vor der Übergabe an den Kunden die Ausschlusskriterien aus dem Profil anwenden. Im Zweifel
den Lead drinlassen und in der Kommentarspalte markieren, der Kunde entscheidet. Nur ein
Kontakt pro Firma, bevorzugt der höchste Entscheider.

## Schritt 4: Longlist-Sheet für die Qualifizierung

Ein neues Google Sheet in Noahs Drive anlegen, Format wie bisher:

Sonia (Namen anonymisiert, Sonia sieht den Nachnamen erst nach Anreicherung):
- Titel: `Podcast_Leads_Sonia_Batch<NN>` (nächste freie Nummer, Stand 30.09.2026: 84)
- Zeile 1: `Podcast-Gäste Longlist Batch <NN> – Sales Hiring / Recruiting Podcast (Sonia)`
- Zeile 2: `Batch <NN>: <Städte / Seiten> - dedupliziert gegen Batch 1-<NN-1>. Bitte 'Qualified' auswählen (Ja / Nein / Vielleicht) + Kommentar.`
- Spalten ab Zeile 4: `#`, `Vorname (Nachname maskiert)`, `Rolle`, `Unternehmen`, `Qualified`, `Kommentar Sonia`

BeeBase (volle Daten, Pascal will LinkedIn sehen):
- Titel: `BeeBase_Podcast_Leads_Batch<NN>` (Stand 30.09.2026: die ersten 300 sind Batch 1, also 2)
- Zeile 1: `Podcast-Leads – BeeBase (ICP: IT-Dienstleistungen für Schweizer KMU)`
- Zeile 2: `Quelle: Apollo.io | Kriterien: CH, 30–150 MA, Geschäftsführer/COO/Head of Ops/IT-Leiter, Branchen Energie/Immobilien/Bau/Facility`
- Spalten ab Zeile 4: `Nr.`, `Name`, `Position`, `Unternehmen`, `Branche`, `Ort`, `LinkedIn`, `E-Mail`, `Qualifiziert`, `Kommentar (Kunde)`
- LinkedIn und E-Mail werden erst nach Anreicherung gefüllt.

## Schritt 5: Anreicherung (kostet Credits)

Erst nach Freigabe. Vorher `apollo_usage_stats_credit_usage_stats` aufrufen und die
verbleibenden `lead_credit` nennen. Pro Lead ein Credit. Stand 30.09.2026: 1.346 von 2.500
übrig, Zyklus endet am 14.10.2026. Wenn die Anzahl die Credits übersteigt, vorher fragen.

`apollo_people_bulk_match` mit den Apollo-IDs, maximal 10 pro Aufruf, keine Telefonnummern,
kein Waterfall. Aus der Antwort übernehmen: `email`, `email_status`, `linkedin_url`,
`last_name`, Ort, Branche. Nur `verified` gilt als sicher; `extrapolated` mitnehmen, aber in
der Statusspalte kennzeichnen.

Erfahrungswerte: Sonia 300 angereichert, 289 mit E-Mail (96 Prozent). BeeBase 300
angereichert, 264 mit E-Mail.

## Schritt 6: Ergebnis-Sheets

Sonia, zwei Sheets wie bisher:
- `Podcast_Leads_Sonia_MIT_EMAIL_Batch<NN>`: `#`, `Vorname (Nachname maskiert)`, `Rolle`, `Unternehmen`, `E-Mail`
- `Podcast_Leads_Sonia_NOCH_ANREICHERN_Batch<NN>`: dieselben Leads ohne E-Mail, Spalten `#`, `Vorname`, `Rolle`, `Unternehmen`; in Zeile 2 notieren, wie viele schon versucht wurden.

BeeBase, ein Sheet:
- `BeeBase_<Anzahl>_enriched_Batch<NN>`: `Nr.`, `Unternehmen`, `Branche`, `Position`, `Vorname`, `Nachname`, `E-Mail`, `Email-Status`

Die Sheets für Stephen und Michelle freigeben (Stephen musste bisher zweimal um Zugriff bitten).

## Schritt 7: Übergabe in Slack

Post in `#onstage-fullfillment` (Kanal-ID `C099G892UAU`), Stephen (`U0AFN71NFHN`) für den
Instantly-Upload und Michelle (`U098VLB5JVA`) für die Mailing-Texte taggen. Inhalt: Kunde,
Batch-Nummer, Anzahl gesucht, nach Dedupe, mit E-Mail, verbrauchte Credits, Sheet-Links,
Hinweis auf fehlende Blacklist falls zutreffend. Nicht ohne Rückfrage posten, wenn der
Auftraggeber nur die Liste wollte.

## Schritt 8: Kurzbericht

Am Ende in einer Tabelle: Suchläufe (Stadt/Branche, Seite), Treffer, nach Dedupe, nach
Vorfilter, angereichert, mit E-Mail, Credits vorher/nachher, Links zu allen Sheets.
