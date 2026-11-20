#!/usr/bin/env bash
# Läuft die Paketprüfung (paketpruefung.py) und zeigt zusätzlich die ausstehenden Updates des Systems (apt-get -s upgrade, nur Zahl und Beispiele).
# Benötigt: dpkg, apt, python3. Ändert nichts am System. Die Hinweisliste ist frei erfunden und enthält keine echten Schwachstellen.
cd "$(dirname "$0")" || exit 1
echo "## 1. Paketprüfung mit der erfundenen Hinweisliste"; python3 paketpruefung.py beispiel_hinweise.csv
echo; echo "## 2. Ausstehende Aktualisierungen laut apt (Simulation, keine Installation)"
apt-get -s upgrade 2>/dev/null | grep -c '^Inst' | sed 's/^/Pakete mit verfügbarer Aktualisierung: /'
echo "(die Namen hängen vom Testsystem ab und werden nicht gezeigt)"
