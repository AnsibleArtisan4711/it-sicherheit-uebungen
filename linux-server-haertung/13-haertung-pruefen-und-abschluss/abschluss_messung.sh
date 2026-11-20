#!/usr/bin/env bash
# Messung vorher/nachher: Prüfkatalog und Lynis-Härtungsindex vor und nach dem Anwenden der Maßnahmen, anschließend Rücknahme.
# Benötigt: lynis, root; ruft haertung_anwenden.sh und pruefkatalog.sh aus demselben Ordner auf. Dauer etwa zwei Minuten (zwei Lynis-Läufe).
set -u
cd "$(dirname "$0")" || exit 1; . ../lab.sh
idx() { lynis audit system --quick --no-colors --quiet >/dev/null 2>&1; R=/var/log/lynis-report.dat
  echo "Lynis-Härtungsindex: $(grep -m1 '^hardening_index=' $R | cut -d= -f2)   Warnungen: $(grep -c '^warning\[\]=' $R)   Vorschläge: $(grep -c '^suggestion\[\]=' $R)"; }
trap 'bash haertung_anwenden.sh zurueck >/dev/null 2>&1' EXIT
step "1. Vorher: Prüfkatalog"; bash pruefkatalog.sh
step "2. Vorher: Lynis"; idx; cp /var/log/lynis-report.dat /tmp/p14-vorher.dat
step "3. Maßnahmen anwenden"; bash haertung_anwenden.sh anwenden
step "4. Nachher: Prüfkatalog"; bash pruefkatalog.sh
step "5. Nachher: Lynis"; idx
step "6. Welche Lynis-Vorschläge sind verschwunden? (Testnummern)"
diff <(grep '^suggestion\[\]=' /tmp/p14-vorher.dat | sed 's/^suggestion\[\]=//; s/|.*//' | sort -u) <(grep '^suggestion\[\]=' /var/log/lynis-report.dat | sed 's/^suggestion\[\]=//; s/|.*//' | sort -u) | grep '^<' | sed 's/^< //' | tr '\n' ' ' | fold -s -w 90; echo
rm -f /tmp/p14-vorher.dat
step "7. Zurücksetzen und erneut prüfen"; bash haertung_anwenden.sh zurueck; bash pruefkatalog.sh | tail -1
