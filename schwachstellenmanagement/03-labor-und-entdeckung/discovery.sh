#!/usr/bin/env bash
# Entdeckt Hosts und Dienste im Labornetz 10.15.0.0/24 mit Nmap (Ping-Scan, SYN-Scan, Dienst- und Versionserkennung) und erzeugt eine Bestandsliste (CSV).
# Benötigt: nmap, python3, ip, nginx, openssh-server, nc, root. Scannt ausschließlich das Labor (Namespaces p15-sc und p15-lx).
set -u
cd "$(dirname "$0")" || exit 1; . ../lab.sh
trap lab_down EXIT; lab_up; ziel_vorher
N="on sc nmap -n"
step "1. Werkzeug"; nmap --version | head -1
step "2. Host-Erkennung im Netz (nmap -sn 10.15.0.0/24)"
$N -sn 10.15.0.0/24 | grep -E 'Nmap scan report|Host is up|Nmap done' | sed -E 's/ \(.*latency\)//; s/ in [0-9.]+ seconds//'
step "3. Alle TCP-Ports des Ziels (SYN-Scan, -p-): offene Ports"
$N -Pn -sS -p- --open 10.15.0.11 | grep -E '^[0-9]+/'
step "4. Dienst- und Versionserkennung der offenen Ports (-sV)"
$N -Pn -sV -p 22,80,443,2323,8080 10.15.0.11 -oX /tmp/p15-disc.xml >/dev/null
grep -E '^[0-9]+/' <($N -Pn -sV -p 22,80,443,2323,8080 10.15.0.11) | sed -E 's/ +/ /g'
step "5. Bestandsliste aus der XML-Ausgabe (nmap_nach_csv.py)"
python3 nmap_nach_csv.py /tmp/p15-disc.xml
step "6. Bestimmte Adressen vom Scan ausnehmen (--exclude), z. B. den Scanner selbst"
$N -sn 10.15.0.0/24 --exclude 10.15.0.2 | grep -c 'Nmap scan report' | sed 's/^/gefundene Hosts ohne Scanner: /'
rm -f /tmp/p15-disc.xml
