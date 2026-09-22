# JOIN – Testvideo-Prozess für die Videoredakteur-Stellen

Stand: 22.09.2026. Ohne JOIN-API (Standard-Plan, API erst ab Advanced) und ohne
Zugriff auf join.com aus der Claude-Umgebung. Der Prozess läuft deshalb über
Gmail (JOIN-Relay) und Slack.

## Ausgangslage

| Was | Wert |
|---|---|
| Offene Stellen | „Freelance Video Editor (M/W/D) - Remote“ (Job 15322023), „YouTube Video Cutter (M/W/D) - 100 % remote“ (Job 15322024) |
| JOIN-Postfach | jobs@onstage.berlin, landet im Gmail von noah@onstage.berlin |
| Kandidaten-Nachrichten | kommen von `<ID>@onstage.msg.join.com`; eine Gmail-Antwort an diese Adresse erreicht den Kandidaten über JOIN |
| Slack-Kanal | #core-team-onstage (C0BT83C1RQX) |
| Gedächtnis der Routine | der Slack-Kanal selbst: jeder Post trägt `gmail:<Thread-ID>`, Entscheidungen stehen als Thread-Antwort darunter (der Gmail-Connector darf keine Labels setzen) |

## Schritt 1 – Einladung zum Testvideo (manuell in JOIN)

Die Angabe „spricht Deutsch“ liegt nur in JOIN (Screening-Frage). Deshalb einmalig von Hand:

1. In JOIN pro Stelle auf „Bewerbungen“ gehen (`https://join.com/jobs/15322023/applications` und `…/15322024/applications`).
2. Filter auf die Screening-Frage zur deutschen Sprache setzen (Antwort „Ja“ bzw. Niveau ≥ B2, je nachdem wie die Frage formuliert ist).
3. Alle gefilterten Kandidaten auswählen und die Vorlage **„Testedit / Testvideo-Einladung“** als Nachricht senden (Mehrfachauswahl → „Nachricht senden“; falls die Mehrfachaktion im Standard-Plan fehlt: einzeln).
4. Die Kandidaten in JOIN in die Pipeline-Stufe „Testvideo angefragt“ (o. ä.) verschieben, damit die Sortierung in JOIN stimmt.
5. Kandidaten ohne Deutsch-Angabe bleiben unberührt (oder bekommen die Absage-Vorlage).

Ab hier übernimmt die Routine.

## Schritt 2 – Automatik (Claude-Routine „JOIN Testvideos → Slack“, stündlich)

Was die Routine bei jedem Lauf macht:

1. **Neue Testvideos erkennen.** Sucht in Gmail nach neuen Nachrichten von `@onstage.msg.join.com`
   (und direkten Mails an jobs@/info@ mit „Testvideo/Testedit“), die einen Video-Link
   (Google Drive, Frame.io, Loom, YouTube, Vimeo, Dropbox, WeTransfer) oder einen Video-Anhang enthalten.
2. **Slack-Post.** Für jedes neue Testvideo eine Nachricht in #core-team-onstage:
   „🎬 Neues Testvideo ist da“ mit Name, Stelle, Link, kurzer Notiz des Kandidaten und Link zum Gmail-Thread.
   Der Post enthält `gmail:<Thread-ID>`; vor jedem Post prüft die Routine, ob diese ID im Kanal schon gemeldet wurde (verhindert Doppelmeldungen).
3. **Entscheidung per Reaktion.** Wer das Video geprüft hat, reagiert auf den Slack-Post:
   - 👍 oder ✅ → Routine antwortet dem Kandidaten über den JOIN-Relay mit der Vorlage **„Einladung Kennenlern-Call“** (Calendly).
   - 👎 oder ❌ → Routine antwortet mit der Vorlage **„Absage + Talent Pool“**.
   - Die Routine bestätigt im Slack-Thread, was gesendet wurde. Beide Reaktionen gleichzeitig → nichts senden, Rückfrage im Thread.
4. Nichts Neues → kein Post, keine Mail.

Nicht automatisiert (kein JOIN-Zugriff): die Pipeline-Stufe in JOIN wird nicht mitgezogen.
Das bleibt ein Handgriff in JOIN; bis dahin ist der Slack-Kanal (Post + Thread-Bestätigung) die Sortierung.

## Vorlagen

Rekonstruiert aus versendeten JOIN-Nachrichten (Feb. 2026). Bitte einmal mit den Vorlagen in JOIN
abgleichen; die Routine nutzt die beiden unteren Texte wörtlich.

### Testedit / Testvideo-Einladung (wird in JOIN versendet, Schritt 1)

> Hallo {Vorname}
>
> Glückwunsch – du bist eine Runde weiter. Dein Profil hat uns überzeugt, und wir würden dich gerne näher kennenlernen.
>
> Der nächste Schritt ist ein kurzer Testedit. Uns ist wichtig, dass du dabei ein gutes Gefühl für unsere Inhalte, den Anspruch und die Zusammenarbeit bekommst – und wir für deinen Stil und dein Qualitätslevel.
>
> Bitte schneide die ersten 15–60 Sekunden dieses Videos:
> 👉 {Drive-Ordner mit Rohmaterial}
>
> Hier findest du den YouTube-Kanal des Kunden, um CI, Stil und Tonalität zu verstehen:
> 👉 {Kunden-Kanal}
>
> Das Qualitätslevel, das wir erwarten, orientiert sich an folgenden Beispielen:
> 👉 {Beispiel 1} 👉 {Beispiel 2} 👉 {Beispiel 3}
>
> Unsere Video-Editoren starten bei 200 € pro Video (in der Regel ca. 12 Minuten Länge).
> Falls dieses Budget nicht in deine Preisvorstellungen passt, gib uns bitte kurz und ehrlich Feedback – dann ist der Testedit nicht notwendig.
>
> Wenn du aktuell nicht annähernd auf dem Qualitätsniveau der oben verlinkten Beispiele editieren kannst, musst du den Testedit ebenfalls nicht einsenden. Es geht nicht darum, die Qualität 1:1 zu treffen, sie sollte aber möglichst nah an das gezeigte Niveau herankommen.
>
> Bitte lade den Testedit als öffentlich einsehbares Video hoch, z. B. über Google Drive oder Frame.io. Bitte kein WeTransfer oder andere Tools, die einen Download erfordern.
>
> Wenn dein Test überzeugt, laden wir dich zu einem bezahlten Videoauftrag und einem Interview ein. Langfristig suchen wir Editor:innen, die Lust haben, auf hohem Niveau zu arbeiten und gemeinsam starke YouTube-Inhalte aufzubauen.
>
> Wir freuen uns auf deine Einsendung – und vielleicht auf die Zusammenarbeit.
>
> Viele Grüße
> Team OnStage

### Einladung Kennenlern-Call (Routine, bei 👍)

> Hallo {Vorname},
>
> wir haben uns dein Ergebnis angeschaut - und sind interessiert, dich besser kennenzulernen!
>
> Lass uns in einem kurzen Google Meet Call (15 Minuten) checken, ob wir zueinander passen und wie der nächste Schritt für dich aussehen könnte.
>
> Trag dich einfach über folgenden Link so früh wie möglich in meinen Kalender ein:
> 👉 https://calendly.com/noah-schering/onstage-jobinterview
>
> Wir freuen uns auf das Gespräch mit dir!
>
> Viele Grüße
> Noah

### Absage + Talent Pool (Routine, bei 👎)

> Hallo {Vorname},
>
> danke dir für das Testvideo – wir haben es uns in Ruhe angeschaut.
> Das Editing ist solide und zeigt, dass du ein gutes Grundverständnis mitbringst.
>
> Für eine direkte Zusammenarbeit reicht es aktuell noch nicht ganz an das Niveau heran, das wir bei Kundenprojekten erwarten.
> Wir sehen aber Potenzial und würden dich deshalb gerne in unseren Talent Pool aufnehmen.
>
> Sobald wir ein Projekt oder eine Phase haben, die gut zu deinem aktuellen Level passt, melden wir uns gerne proaktiv bei dir.
>
> Wenn du dich in der Zwischenzeit weiterentwickeln möchtest, können wir dir diesen YouTube-Kanal sehr empfehlen – dort findest du viele starke Editing-Ansätze speziell für YouTube:
> 👉 https://www.youtube.com/@josephvideoediting
>
> Danke dir für den Einsatz – und weiterhin viel Erfolg beim Weiterentwickeln.
>
> Viele Grüße
> Noah

## Später, wenn die JOIN-API da ist (Advanced-Plan + Netzwerkfreigabe)

- Schritt 1 komplett automatisieren: Bewerbungen per API lesen, Screening-Antwort „Deutsch“ filtern, Vorlage per API senden.
- Pipeline-Stufen in JOIN automatisch setzen.
