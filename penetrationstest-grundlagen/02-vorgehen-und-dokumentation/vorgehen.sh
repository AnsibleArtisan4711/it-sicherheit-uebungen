#!/usr/bin/env bash
# Modul 2: Vorgehen und Dokumentation. Phasen eines Tests, Notizen mit Beleg (Prüfsumme der Rohausgabe), Zusammenfassung. Nur eigenes Loopback-Labor.
. "$(dirname "$0")/../lab.sh"
lab_up
step "1. Phasen (Modell): jede Phase hat Eingabe, Ergebnis und Beleg"
cat <<'T'
1 Vorbereitung   Auftrag, Scope, Regeln          -> Auftragsdatei
2 Aufklärung     offene Dienste, Banner          -> Liste der Dienste
3 Bewertung      Schwachstellen und Fehlkonfig.  -> Befunde mit Beleg
4 Nachweis       nur soweit erlaubt, ohne Schaden -> kurzer Nachweis
5 Bericht        Befunde, Risiko, Empfehlung      -> Bericht
6 Nachbereitung  Daten löschen, Rückfragen        -> Abschluss
T
step "2. Notizfunktion: laufende Nummer, Befund, Rohausgabe-Prüfsumme (Zeitstempel bewusst weggelassen)"
LOG="$W/befunde.jsonl"; : > "$LOG"
befund() {  # befund TITEL SCHWERE BEFEHL...
  local titel="$1" schwere="$2"; shift 2
  local roh; roh="$("$@" 2>&1)"
  python3 - "$titel" "$schwere" "$roh" "$*" "$LOG" <<'PY'
import sys, json, hashlib
titel, schwere, roh, befehl, log = sys.argv[1:6]
n = sum(1 for _ in open(log)) + 1
json.dump({'nr': n, 'titel': titel, 'schwere': schwere, 'befehl': befehl, 'beleg_sha256': hashlib.sha256(roh.encode()).hexdigest()[:16], 'zeilen': roh.count('\n') + 1}, open(log, 'a'), ensure_ascii=False)
open(log, 'a').write('\n')
PY
}
befund "Server-Header nennt Produkt und Version" niedrig bash -c "curl -sI 127.0.0.1:$APP/ | grep -i ^server"
befund "robots.txt verrät sensible Pfade" niedrig curl -s 127.0.0.1:$APP/robots.txt
befund "Sicherung öffentlich abrufbar" hoch curl -s 127.0.0.1:$APP/backup/db.bak.txt
python3 -c "
import json
for z in open('$LOG'):
    d = json.loads(z); print('%d | %-8s | %-42s | %s | %d Zeilen' % (d['nr'], d['schwere'], d['titel'], d['beleg_sha256'], d['zeilen']))"
step "3. Beleg prüfen: derselbe Befehl liefert dieselbe Prüfsumme (Belege nur für feste Antworten)"
a=$(printf '%s' "$(curl -s 127.0.0.1:$APP/backup/db.bak.txt)" | sha256sum | cut -c1-16); b=$(sed -n 3p "$LOG" | grep -o '"beleg_sha256": "[0-9a-f]*"' | grep -o '[0-9a-f]\{16\}')
echo "neu: $a  gespeichert: $b  gleich: $([ "$a" = "$b" ] && echo ja || echo nein)"
step "4. Veränderliche Antworten: die Kopfzeile Date ändert sich, die Prüfsumme nicht wiederholbar"
h1=$(curl -sI 127.0.0.1:$APP/ | sha256sum | cut -c1-8); sleep 1.1; h2=$(curl -sI 127.0.0.1:$APP/ | sha256sum | cut -c1-8)
echo "Prüfsummen gleich: $([ "$h1" = "$h2" ] && echo ja || echo nein)"
echo "Belege deshalb mit Zeitpunkt und Rohdatei sichern."
