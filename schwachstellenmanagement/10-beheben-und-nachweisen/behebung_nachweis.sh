#!/usr/bin/env bash
# Behebung nachweisen: Scan vorher, Maßnahmen (Zielsystem wird im gehärteten Zustand neu gestartet), Scan nachher, Vergleich.
# Benötigt: nmap, python3, nginx, openssh-server, socat, openssl, root. Scannt nur das Labor 10.15.0.0/24.
set -u
cd "$(dirname "$0")" || exit 1; . ../lab.sh
trap lab_down EXIT; lab_up; ziel_vorher
V=/tmp/p15-vorher.csv; N=/tmp/p15-nachher.csv
step "1. Erster Scan (Ausgangslage)"
scan_befunde 10.15.0.11 $V; cut -d';' -f1-6 $V | sed 's/;/ | /g'
step "2. Maßnahmen umsetzen (im Labor: Ziel mit gehärteter Konfiguration neu starten)"
echo "TLS nur 1.2/1.3 mit guten Chiffren, Sicherheits-Header setzen, SSH nur mit Schlüssel, Dateiliste und Klartextdienst abschalten"
ziel_stop; ziel_nachher
step "3. Zweiter Scan (Nachweis)"
scan_befunde 10.15.0.11 $N; cut -d';' -f1-6 $N | sed 's/;/ | /g'
step "4. Vergleich der beiden Scans (scan_vergleich.py)"
python3 scan_vergleich.py $V $N; echo "Rückgabewert: $?"
step "5. Gegenprobe: unvollständige Behebung (nur TLS gehärtet, der Rest bleibt)"
ziel_stop; ziel_teilweise
scan_befunde 10.15.0.11 $N
python3 scan_vergleich.py $V $N > /tmp/p15-vgl.txt; rc=$?; cat /tmp/p15-vgl.txt; echo "Rückgabewert: $rc (ungleich 0 = es bleibt etwas offen oder ist neu)"
rm -f $V $N /tmp/p15-vgl.txt
