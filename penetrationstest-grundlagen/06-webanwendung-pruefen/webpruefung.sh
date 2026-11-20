#!/usr/bin/env bash
# Modul 6: Webanwendung prüfen (nur eigene Beispielanwendung auf Loopback, nur curl, keine Ausnutzung): Eingabe-Echo, offene Sicherung, Fehlerseite, Pfade.
. "$(dirname "$0")/../lab.sh"
lab_up
step "1. Eingabe wird ungeprüft zurückgegeben? Harmloser Marker statt Schadcode"
echo "unsicher: $(curl -s "127.0.0.1:$APP/suche?q=MARKER%3Cb%3Ex%3C/b%3E")"
echo "sicher:   $(curl -s "127.0.0.1:$APP/suche-sicher?q=MARKER%3Cb%3Ex%3C/b%3E")"
echo "Deutung: Im unsicheren Fall steht das Tag <b> unverändert im Ergebnis; im sicheren Fall ist es maskiert (&lt;b&gt;). Das ist die Voraussetzung für Cross-Site-Scripting; eine Ausnutzung wird nicht geübt."
step "2. Dateien, die nicht öffentlich sein sollten (Pfade aus robots.txt und übliche Namen aus einer kurzen eigenen Liste)"
printf '%s\n' /admin /backup/db.bak.txt /backup/ /.git/config /config.php /fehler > "$W/pfade.txt"
while read -r p; do printf '%-20s %s\n' "$p" "$(curl -s -o /dev/null -w '%{http_code}' 127.0.0.1:$APP$p)"; done < "$W/pfade.txt"
step "3. Fund bewerten: Inhalt der Sicherung nur ansehen, nicht weiterverwenden"
curl -s 127.0.0.1:$APP/backup/db.bak.txt | sed 's/\(passwort=\).*/\1***(erfundenes Beispiel, maskiert)/'
step "4. Verbose Fehler (Statuscode 500) verrät interne Pfade"
printf 'Status: %s\n' "$(curl -s -o /dev/null -w '%{http_code}' 127.0.0.1:$APP/fehler)"
curl -s 127.0.0.1:$APP/fehler | grep -c '/srv/shop' | sed 's/^/Zeilen mit internem Pfad: /'
step "5. Zugriffsschutz: /admin ohne Anmeldung"
printf 'Status: %s (401 = Anmeldung verlangt)\n' "$(curl -s -o /dev/null -w '%{http_code}' 127.0.0.1:$APP/admin)"
step "6. Ergebnis als Befundliste"
cat <<'T'
W-1 hoch     Sicherung /backup/db.bak.txt öffentlich abrufbar
W-2 mittel   Eingaben der Suche werden unmaskiert ausgegeben
W-3 niedrig  Fehlerseite nennt Pfade und Datenbank
W-4 niedrig  robots.txt nennt sensible Pfade
T
