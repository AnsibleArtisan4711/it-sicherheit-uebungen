#!/usr/bin/env bash
# Misst den Ausgangszustand mit Lynis (Härtungsindex, Warnungen, Vorschläge) und schreibt eine Kennzahlenzeile.
# Benötigt: lynis, root. Ändert nichts am System; Lynis schreibt /var/log/lynis.log und /var/log/lynis-report.dat.
set -u
echo "## Version"; lynis --version
echo; echo "## Lauf (schnell, ohne Farben)"
lynis audit system --quick --no-colors --quiet >/dev/null 2>&1
R=/var/log/lynis-report.dat
echo; echo "## Kennzahlen aus $R"
for k in lynis_version os os_fullname os_version hardening_index; do grep -m1 "^$k=" "$R"; done
echo "warnungen=$(grep -c '^warning\[\]=' "$R")"
echo "vorschlaege=$(grep -c '^suggestion\[\]=' "$R")"
echo "tests_durchgefuehrt=$(grep -m1 '^lynis_tests_done=' "$R" | cut -d= -f2)"
echo; echo "## Erste fünf Vorschläge (Test-ID | Text)"
grep '^suggestion\[\]=' "$R" | head -5 | sed 's/^suggestion\[\]=//' | cut -c1-110
echo; echo "## Kennzahlenzeile für die Tabelle in der Dokumentation"
echo "datum=$(date +%F) index=$(grep -m1 '^hardening_index=' "$R" | cut -d= -f2) warnungen=$(grep -c '^warning\[\]=' "$R") vorschlaege=$(grep -c '^suggestion\[\]=' "$R")"
