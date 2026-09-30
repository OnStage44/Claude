# JOIN – Testvideo-Prozess für die Videoredakteur-Stellen

Stand: 22.09.2026, 17:30 Uhr. Schritt 1 wurde am 22.09. ab 15:38 Uhr aus JOIN heraus ausgelöst (Testedit-Einladungen sind raus). Ohne JOIN-API (Standard-Plan, API erst ab Advanced) und ohne
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
   Der Post enthält `msg:<Message-ID>` und `gmail:<Thread-ID>`; vor jedem Post prüft die Routine, ob die Message-ID im Kanal schon gemeldet wurde (verhindert Doppelmeldungen). Gmail fasst Antworten verschiedener Kandidaten mit gleichem Betreff in einen Thread, deshalb wird jede Nachricht einzeln bewertet.
3. **Eingangsbestätigung an den Kandidaten.** Direkt nach dem Slack-Post antwortet die Routine auf die
   JOIN-Mail des Kandidaten mit der Vorlage **„Eingangsbestätigung Testedit“** (Danke, ist angekommen, wir melden uns).
   Diese Mail und die Einladung bei 👍 sind die einzigen Mails, die die Routine selbst sendet (Entscheidungen Noah, 28.09. und 30.09.2026). Im Slack-Thread steht danach
   „✉️ Eingangsbestätigung gesendet“; fehlt der Eintrag oder steht dort „⚠️ … bitte selbst kurz antworten“, hat der
   Sicherheitsfilter der Claude-Umgebung den Versand abgelehnt und Noah antwortet selbst in JOIN.
4. **Entscheidung per Reaktion.** Wer das Video geprüft hat, reagiert auf den Slack-Post:
   - 👍 oder ✅ → Routine **sendet direkt** die Vorlage **„Einladung Kennenlern-Call“** als Antwort auf die JOIN-Mail
     des Kandidaten (Entscheidung Noah, 30.09.2026). Der Calendly-Link darin ist personalisiert: Name des Kandidaten,
     Link zum Testvideo und Link zur JOIN-Bewerbungsliste des Jobs (dort liegt der CV) sind als Antwort auf die
     Zusatzfrage des Events (`a1`) und als UTM-Parameter vorbelegt, damit Noah beide Links im Kalendereintrag des Calls
     sieht, wenn der Call stattfindet. Im Slack-Thread steht danach „✅ Einladung zum Kennenlern-Call gesendet“.
   - 👎 oder ❌ → Routine legt in Gmail einen Antwort-Entwurf mit der Vorlage **„Absage + Talent Pool“** an und meldet im
     Slack-Thread „📝 Entwurf liegt in Gmail“. **Absenden klickt Noah selbst.**
   - Beide Reaktionen gleichzeitig → nichts passiert, Rückfrage im Thread.
   - Steht im Thread schon „✅“, „📝“ oder „⚠️“, fasst die Routine den Post nicht noch einmal an.
5. Nichts Neues → kein Post, keine Mail, kein Entwurf.

**Calendly-Event für die Einladung:** „Kennenlern-Call Video Editor (15 Min.)“, Slug `kennenlern-call-video-editor-15-min`,
15 Minuten, Google Meet, deutsche Buchungsseite; am 30.09.2026 per Calendly-API angelegt, weil das ältere Event
„OnStage Jobinterview“ als erste Frage eine Pflicht-Telefonnummer hat und die Calendly-API Zusatzfragen nicht anlegen
kann. Das neue Event hat genau eine optionale Zusatzfrage (Calendly-Standardfrage „Bitte geben Sie alles an, was bei der
Vorbereitung auf unser Meeting hilfreich sein könnte.“). Die Routine belegt sie über den URL-Parameter `a1` mit
„Testedit: {Link} | JOIN-Bewerbung (CV): {Link}“ vor; die Antwort steht nach der Buchung im Google-Kalender-Eintrag, in der
Calendly-Bestätigung und in den Termindetails. Nichts weiter einzurichten. Falls Noah in Calendly weitere Fragen vor diese
Frage setzt, muss `a1` in der Routine angepasst werden. JOIN schickt den CV nicht per Mail mit und liefert keinen Link pro
Kandidat, deshalb zeigt der JOIN-Link auf die Bewerbungsliste des Jobs (`https://join.com/jobs/15322023/applications` bzw.
`…/15322024/applications`); dort den Namen suchen, der CV liegt in der Bewerbung.

Nicht automatisiert (kein JOIN-Zugriff): die Pipeline-Stufe in JOIN wird nicht mitgezogen.
Das bleibt ein Handgriff in JOIN; bis dahin ist der Slack-Kanal (Post + Thread-Bestätigung) die Sortierung.

## Vorlagen

### Eingangsbestätigung Testedit (Routine sendet automatisch als Antwort auf die JOIN-Mail)

> Hallo {Vorname},
>
> vielen Dank für deinen Testedit – er ist bei uns angekommen.
>
> Wir schauen uns alle Einsendungen sorgfältig an und melden uns in den nächsten Tagen mit einer Rückmeldung bei dir.
>
> Viele Grüße
> Noah
> Team OnStage

Rekonstruiert aus versendeten JOIN-Nachrichten (Feb. 2026). Bitte einmal mit den Vorlagen in JOIN
abgleichen; die Routine nutzt die beiden unteren Texte wörtlich (Einladung wird gesendet, Absage als Entwurf).

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

### Einladung Kennenlern-Call (Routine sendet automatisch bei 👍; `{Calendly-Link}` = personalisierter Link, siehe Schritt 2, Punkt 4)

> Hallo {Vorname},
>
> wir haben uns dein Ergebnis angeschaut - und sind interessiert, dich besser kennenzulernen!
>
> Lass uns in einem kurzen Google Meet Call (15 Minuten) checken, ob wir zueinander passen und wie der nächste Schritt für dich aussehen könnte.
>
> Trag dich einfach über folgenden Link so früh wie möglich in meinen Kalender ein:
> 👉 {Calendly-Link}
>
> Wir freuen uns auf das Gespräch mit dir!
>
> Viele Grüße
> Noah

### Absage + Talent Pool (Routine legt bei 👎 einen Entwurf an)

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
