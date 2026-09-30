# Podcast-Leads für Sonia und BeeBase: Wie die Listen entstanden sind

Stand: 30.09.2026. Ziel dieses Dokuments: Jeder im Team kann nachvollziehen, wie die
Podcast-Gast-Leads für Sonia und BeeBase gebaut wurden, und mit dem Skill
`.claude/skills/podcast-leads/SKILL.md` weitere Leads nach demselben Verfahren ziehen.

Die ursprünglichen Claude-Chats (28.08. bis 01.09.2026) liegen im Claude.ai-Verlauf von Noah
und sind nicht exportiert. Alles hier wurde aus den erzeugten Sheets, den
Zielgruppen-Dokumenten, Slack und einer Kontrollsuche in Apollo rekonstruiert. Die
Apollo-Filter im Skill liefern dieselben Leads wie damals (Stichprobe: Heiko Bialozyt und
Luca Koch aus der BeeBase-Liste, Stephan Siehl aus der Sonia-Liste).

## So benutzt du den Skill

In Claude Code auf diesem Repo, oder in Claude.ai mit dem Skill hochgeladen
(Einstellungen, Skills, Ordner `.claude/skills/podcast-leads` als Zip), reicht ein Satz:

- "Mach mir 300 weitere Podcast-Leads für BeeBase."
- "Nächster Sonia-Batch, 200 Leads, diesmal VP Sales und Head of Sales."
- "Reichere die 635 Sonia-Leads ohne E-Mail an."

Apollo, Google Drive und Slack müssen als Connectoren verbunden sein. Die Longlist kostet
nichts, die E-Mail-Anreicherung einen Apollo-Credit pro Lead.

## Das Verfahren in einem Absatz

Apollo-Personensuche mit den ICP-Filtern des Kunden (Land oder Stadt, Firmengröße, Titel,
Branchen-Keywords), Treffer gegen alle bisherigen Listen deduplizieren, offensichtliche
Fehltreffer nach dem Kundenfeedback aussortieren, als Google Sheet zur Qualifizierung an den
Kunden geben. Nach Freigabe die Leads über Apollo mit E-Mail anreichern, in "mit E-Mail" und
"noch anreichern" aufteilen, an Stephen für Instantly und Michelle für die Mailing-Texte
übergeben.

## Was bisher passiert ist

| Datum | Kunde | Schritt | Ergebnis |
|---|---|---|---|
| 28.08.2026 | Sonia | Erste Stichprobe, 20 Gründer/CEOs von B2B-SaaS-Firmen in DACH, Namen anonymisiert | [Podcast_Leads_Sonia](https://docs.google.com/spreadsheets/d/1GSG1uwme5xQdVZ3U0jPi9-vNAT1_gWon2Cj4OCiHiIg/edit), Sonia hat 14 von 20 als passend markiert |
| 28.08.2026 | BeeBase | Erste Stichprobe, 18 Entscheider aus CH-KMU (Energie, Immobilien, Bau, Facility) | [BeeBase_Podcast_Leads](https://docs.google.com/spreadsheets/d/1XLjeXtD918k1khSBnoXlXB4PO3NNFJ2LetrTQgAvCrY/edit), Pascal hat 14 als passend markiert |
| 31.08. bis 01.09.2026 | Sonia | 83 Batches, Stadt für Stadt, 1.000 Leads erreicht; die ersten 300 angereichert | [MIT_EMAIL](https://docs.google.com/spreadsheets/d/1bvBkeFkYcDF_viRbXDMkAtMykfJpd5KhAB_tsc7-xCA/edit) (289 Leads), [NOCH_ANREICHERN](https://docs.google.com/spreadsheets/d/1jTgx_DZdlonwwnwhOS_8IIzNQXIjL6GM3-gavtchrVE/edit) (635 Leads), Beispiel-Batches [4](https://docs.google.com/spreadsheets/d/1_7OpEJB1vTMT0KrRLMnbiZi8xHufcM6XaI_37asy8yo/edit), [49](https://docs.google.com/spreadsheets/d/1pKW9cCOrYdBR89Y4AEVl1FQ__rtPyLV65jcki0xlVsk/edit), [83](https://docs.google.com/spreadsheets/d/1_E-7DSiX9h6U4CK2NyTUPN3chxBb6BaE7cXQ7QYDaxI/edit) |
| 31.08. bis 01.09.2026 | BeeBase | 300 Leads gesucht und angereichert | [BeeBase_300_enriched_final](https://docs.google.com/spreadsheets/d/1YuTay1plHiaXewGoARtihLlvolV-8mscWZSN4bpby0k/edit) (264 mit E-Mail) |
| 01.09.2026 | beide | Übergabe an Stephen in #onstage-fullfillment für Instantly | Cold-Mailing-Setup läuft, erste Podcast-Anfrage für Sonia am 18.09. (Philipp Schuch, gradar) |

## Zielgruppen in Kurzform

**Sonia**: Founder, CEO, Geschäftsführer, Managing Director oder CRO von B2B-SaaS- und
Tech-Firmen mit 20 bis 500 Mitarbeitern in DACH, Fokus Deutschland. Zweite, noch nicht
abgesuchte Gruppe: VP Sales und Head of Sales. Raus: Softwareentwicklung ohne eigenes
Produkt, Agenturen, Wettbewerber ihrer aktuellen Kunden.
Quelle: [Zielgruppenverständnis Sonia](https://docs.google.com/document/d/1xrF3wgn-16cmn4PAurXRE5VWDDAtf5yoAxDkNCFhqQg/edit).

**BeeBase**: Geschäftsführer, COO, Head of Operations, Betriebsleiter oder IT-Leiter von
Schweizer KMU mit 30 bis 150 Mitarbeitern in Energie, Immobilien, Bau, Handwerk, Reinigung
und Facility, bevorzugt Deutschschweiz. Raus: zu große Gruppen, Firmen mit eigener IT oder
IT-Angebot, mehr als ein Kontakt pro Firma.
Quelle: [Zielgruppenverständnis BeeBase](https://docs.google.com/document/d/1D8vUORSa8YIWMnzlrvK3WSbmFwQ0TqaH3MTszhihP9g/edit).

Die genauen Apollo-Filter stehen im Skill.

## Offene Punkte

- **Blacklist** fehlt bei beiden Kunden (Bestandskunden und No-Go-Firmen). Muss vor jedem
  Instantly-Upload eingeholt und in Instantly hinterlegt werden (Noah, Slack 20.09.2026).
- **Sonia, 635 Leads ohne E-Mail**: noch nicht angereichert, wartet auf das Ergebnis von
  Batch 1. Kostet rund 635 Credits.
- **Apollo-Credits**: 1.346 von 2.500 übrig, Zyklus endet am 14.10.2026.
- **Nächste Batch-Nummern**: Sonia 84, BeeBase 2.
