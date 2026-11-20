#!/usr/bin/env bash
# Modul 8: Bericht und Abschlussprojekt. Befunde (aus eigenen Prüfungen des Labors) werden bewertet und als Berichtstext ausgegeben.
. "$(dirname "$0")/../lab.sh"
lab_up
step "1. Befunde sammeln (feste Prüfungen gegen das Labor, Rohdaten in der Datei befunde.tsv)"
B="$W/befunde.tsv"; : > "$B"
add() { printf '%s\t%s\t%s\t%s\t%s\n' "$@" >> "$B"; }
[ "$(curl -s -o /dev/null -w '%{http_code}' 127.0.0.1:$APP/backup/db.bak.txt)" = 200 ] && add B-1 "Sicherung öffentlich abrufbar" 3 3 "Datei entfernen, Zugriff sperren, enthaltene Kennwörter ersetzen"
curl -s "127.0.0.1:$APP/suche?q=%3Cb%3E" | grep -q '<b>' && add B-2 "Suchausgabe nicht maskiert" 2 2 "Ausgabe maskieren (HTML-Escape), Eingaben prüfen"
[ "$(curl -s -o /dev/null -w '%{http_code}' 127.0.0.1:$APP/fehler)" = 500 ] && add B-3 "Fehlerseite nennt interne Pfade" 2 1 "Allgemeine Fehlermeldung, Details nur ins Protokoll"
[ "$(for i in 1 2 3 4; do curl -s -o /dev/null -w '%{http_code}\n' -d user=demo -d pw=falsch-1 127.0.0.1:$APP/login; done | grep -c 401)" = 4 ] && add B-4 "Keine Sperre nach Fehlversuchen" 2 2 "Begrenzung und Wartezeit einführen"
curl -sI 127.0.0.1:$APP/ | grep -qi '^server:.*/' && add B-5 "Server-Kopfzeile nennt Produkt und Version" 1 1 "Angabe entfernen oder verkürzen"
curl -s -i -X OPTIONS 127.0.0.1:$APP/ | grep -i '^allow:' | grep -q TRACE && add B-6 "TRACE wird angeboten" 1 1 "Methode deaktivieren"
awk -F'\t' '{printf "%s  %-45s W=%s A=%s\n", $1, $2, $3, $4}' "$B"
step "2. Bewertung: Risiko = Wahrscheinlichkeit × Auswirkung (je 1 bis 3)"
awk -F'\t' '{r=$3*$4; s=(r>=6?"hoch":(r>=3?"mittel":"niedrig")); printf "%s  Risiko %d (%s)  %s\n", $1, r, s, $2}' "$B" | sort -k3,3nr -k1,1
step "3. Berichtstext (Gerüst; Zahlen aus dieser Prüfung)"
n=$(wc -l < "$B"); h=$(awk -F'\t' '$3*$4>=6' "$B" | wc -l); m=$(awk -F'\t' '$3*$4>=3 && $3*$4<6' "$B" | wc -l); l=$(awk -F'\t' '$3*$4<3' "$B" | wc -l)
cat <<T
Zusammenfassung
Geprüft wurde ausschließlich das Beispiel-Labor (127.0.0.1) im vereinbarten Rahmen. Es wurden $n Befunde festgestellt: $h hoch, $m mittel, $l niedrig.
Der wichtigste Befund ist B-1 (abrufbare Sicherung), weil dort Zugangsdaten stehen. Empfohlen wird, ihn zuerst zu beheben.

Maßnahmenliste
T
awk -F'\t' '{printf "- %s: %s\n", $1, $5}' "$B"
step "4. Qualitätsprüfung des Berichts"
echo "Jeder Befund hat Nummer, Titel, Bewertung und Empfehlung: $(awk -F'\t' 'NF==5 && $5!=""' "$B" | wc -l) von $n vollständig"
echo "Bericht nennt keine echten Kennwörter: $(grep -c 'Beispiel-Pw' "$B") Treffer in den Rohdaten (erwartet 0)"
