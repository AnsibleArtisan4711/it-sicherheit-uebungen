#!/usr/bin/env bash
# Modul 3: Aufklärung eigener Systeme: lauschende Ports am eigenen Rechner, Banner, Kopfzeilen, robots.txt. Nur Loopback-Labor.
. "$(dirname "$0")/../lab.sh"
lab_up
step "1. Von innen: welche Ports lauschen auf 127.0.0.1 (nur unsere Labor-Ports)?"
ss -ltn 2>/dev/null | awk 'NR>1 {print $4}' | grep -E "^127.0.0.1:($APP|$APP2|$SSHP|$FTPP)$" | sort -t: -k2 -n
step "2. Banner lesen (zwei Dienste senden beim Verbinden einen Text)"
for p in $SSHP $FTPP; do printf 'Port %s: ' $p; python3 - $p <<'PY'
import socket, sys
s = socket.create_connection(('127.0.0.1', int(sys.argv[1])), 2); s.settimeout(2); print(s.recv(100).decode().strip()); s.close()
PY
done
step "3. Webdienst: Kopfzeilen (ohne Datum)"
cmd curl -sI 127.0.0.1:$APP/ | grep -iv '^date'
step "4. robots.txt: Hinweise für Suchmaschinen, die auch Pfade verraten"
cmd curl -s 127.0.0.1:$APP/robots.txt
step "5. Auswertung der Pfade aus robots.txt (nur Statuscodes, keine Inhalte betrachten)"
for p in $(curl -s 127.0.0.1:$APP/robots.txt | awk '/Disallow/ {print $2}'); do printf '%-10s %s\n' "$p" "$(curl -s -o /dev/null -w '%{http_code}' 127.0.0.1:$APP$p)"; done
step "6. Dasselbe passiv: was verrät der Dienst über sich?"
echo "Server: $(curl -sI 127.0.0.1:$APP/ | tr -d '\r' | awk -F': ' 'tolower($1)=="server" {print $2}')"
