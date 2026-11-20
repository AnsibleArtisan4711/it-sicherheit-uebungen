#!/usr/bin/env bash
# Nmap-Skripte (NSE) gegen das Laborziel: TLS-Chiffren, SSH-Anmeldearten, HTTP-Titel und -Header, Banner; danach Befunde nach Regeln (nmap_befunde.py).
# Benötigt: nmap (mit NSE-Skripten), python3, nginx, openssh-server, socat, openssl, root. Scannt nur das Labor 10.15.0.0/24.
set -u
cd "$(dirname "$0")" || exit 1; . ../lab.sh
trap lab_down EXIT; lab_up; ziel_vorher
N="on sc nmap -n -Pn"
step "1. TLS (ssl-enum-ciphers): angebotene Protokolle und Güte"
$N -p 443 --script ssl-enum-ciphers 10.15.0.11 | grep -E '^\|   TLSv|least strength|warnings|Anonymous' | sed -E 's/ +$//'
step "2. SSH (ssh-auth-methods): erlaubte Anmeldearten"
$N -p 22 --script ssh-auth-methods 10.15.0.11 | sed -n '/ssh-auth-methods/,/^$/p' | sed '/^$/d;/^MAC/d' | head -8
step "3. HTTP (http-title, http-headers) auf 80, 8080 und 443"
$N -p 80,8080,443 --script http-title,http-headers 10.15.0.11 | grep -E '^[0-9]+/|http-title|Server:|Strict-Transport|Content-Type' | sed -E 's/ +$//'
step "4. Banner (banner) des unbekannten Dienstes auf Port 2323"
$N -p 2323 --script banner 10.15.0.11 | grep -E '^[0-9]+/|banner|login' | sed -E 's/ +$//' | tr -d '\r'
step "5. Auswertung nach Regeln (nmap_befunde.py) – XML mit allen Skripten"
$N -sV -p 22,80,443,2323,8080 --script ssl-enum-ciphers,ssh-auth-methods,http-title,http-headers,banner 10.15.0.11 -oX /tmp/p15-skripte.xml >/dev/null 2>&1
python3 nmap_befunde.py /tmp/p15-skripte.xml
rm -f /tmp/p15-skripte.xml
