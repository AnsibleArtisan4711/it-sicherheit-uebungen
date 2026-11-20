#!/usr/bin/env bash
# Eine vollständige Runde im Labor: Freigabe prüfen, Bestand erfassen, scannen, bewerten und priorisieren, beheben, erneut scannen, vergleichen, Kennzahl.
# Benötigt: nmap, python3, nginx, openssh-server, socat, openssl, root. Scannt nur das Labor 10.15.0.0/24.
set -u
cd "$(dirname "$0")" || exit 1; . ../lab.sh
D=$(pwd)/..; V=/tmp/p15-r-vorher.csv; N=/tmp/p15-r-nachher.csv
trap 'lab_down; rm -f $V $N /tmp/p15-r-*.csv' EXIT; lab_up; ziel_vorher
step "1. Freigabe prüfen (02/scan_freigabe.py)"
python3 $D/02*/scan_freigabe.py $D/02*/freigabe.csv 10.15.0.11 10.15.0.1 | tail -2
step "2. Scan und Befunde (Ausgangslage)"
scan_befunde 10.15.0.11 $V; cut -d';' -f1,3,5,6 $V | sed 's/;/ | /g'
step "3. Bewertung und Priorisierung (Kritikalität 3, intern; EPSS und KEV hier nur angenommen)"
printf 'host;name;kritikalitaet;exposition\n10.15.0.11;ziel01;3;intern\n' > /tmp/p15-r-assets.csv
awk -F';' 'NR==1{print "id;host;titel;cvss_vektor;epss;kev";next}{print $1";"$2";"$5";"$7";0.05;nein"}' $V > /tmp/p15-r-befunde.csv
python3 $D/09*/priorisieren.py /tmp/p15-r-befunde.csv /tmp/p15-r-assets.csv | sed -n 1,7p
step "4. Behebung (Ziel im gehärteten Zustand neu starten) und Nachscan"
ziel_stop; ziel_nachher; scan_befunde 10.15.0.11 $N
step "5. Vergleich"
python3 $D/10*/scan_vergleich.py $V $N; echo "Rückgabewert: $?"
step "6. Kennzahl dieser Runde"
a=$(( $(wc -l < $V) - 1 )); b=$(( $(wc -l < $N) - 1 ))
echo "Befunde vorher: $a, nachher: $b, Behebungsquote: $(( (a-b)*100/a )) %"
