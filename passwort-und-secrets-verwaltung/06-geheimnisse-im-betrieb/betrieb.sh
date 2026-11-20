#!/usr/bin/env bash
# Modul 6: Geheimnisse im Betrieb: Argumente, Umgebung und Dateien. Wer kann sie sehen? Alle Werte sind erfunden.
. "$(dirname "$0")/../lab.sh"
lab_up
step "1. Geheimnis als Argument: im Prozess für andere sichtbar (/proc/PID/cmdline)"
python3 -c "import time; time.sleep(30)" --beispiel-passwort=Beispiel-Geheim-4 & P1=$!
sleep 0.3; echo "cmdline: $(tr '\0' ' ' < /proc/$P1/cmdline)"; echo "ps zeigt: $(ps -o args= -p $P1)"
kill $P1 2>/dev/null; wait $P1 2>/dev/null
step "2. Geheimnis in der Umgebung: nur für denselben Benutzer lesbar, aber an Kindprozesse vererbt"
APP_PASSWORD=Beispiel-Geheim-5 sleep 30 & P2=$!
sleep 0.3
echo "Rechte von /proc/PID/environ: $(stat -c '%a %U' /proc/$P2/environ)"
echo "Inhalt (als derselbe Benutzer): $(tr '\0' '\n' < /proc/$P2/environ | grep APP_PASSWORD)"
APP_PASSWORD=Beispiel-Geheim-5 bash -c 'bash -c "echo Kindprozess sieht: \$APP_PASSWORD"'
kill $P2 2>/dev/null; wait $P2 2>/dev/null
step "3. Geheimnis in einer Datei: Standardrechte (umask 022) gegen umask 077 und chmod 600"
umask 022; echo "Beispiel-Geheim-6" > "$W/standard.txt"
( umask 077; echo "Beispiel-Geheim-6" > "$W/umask077.txt" )
echo "Beispiel-Geheim-6" > "$W/chmod.txt"; chmod 600 "$W/chmod.txt"
stat -c '%n %a' "$W/standard.txt" "$W/umask077.txt" "$W/chmod.txt" | sed "s#$W/##"
echo "Hinweis: Bei chmod nach dem Schreiben war die Datei kurz mit 644 lesbar; mit umask 077 vorher nie."
step "4. Besser: Geheimnis aus Datei lesen, nicht über das Argument (Programm liest stdin oder Datei)"
python3 - "$W" <<'PY'
import sys, subprocess
d = sys.argv[1]
open(d + "/pw", "w").write("Beispiel-Geheim-7\n")
p = subprocess.Popen(["python3", "-c", "import sys,time; pw=open(sys.argv[1]).read().strip(); time.sleep(2)", d + "/pw"])
import time; time.sleep(0.5)
print("cmdline:", open(f"/proc/{p.pid}/cmdline").read().replace("\0", " ").replace(d, "<W>"))
print("Das Argument nennt nur den Pfad der Datei, nicht den Wert.")
p.wait()
PY
step "5. In Protokollen maskieren: Muster ersetzen, bevor eine Zeile geschrieben wird (Modell)"
python3 - <<'PY'
import re
def maske(z): return re.sub(r"(?i)((?:password|passwort|token|secret)\s*=\s*)\S+", r"\1***", z)
for z in ("login ok user=anna", "connect password=Beispiel-Geheim-8 host=db01", "TOKEN=abc123 sent"): print(maske(z))
PY
lab_down
