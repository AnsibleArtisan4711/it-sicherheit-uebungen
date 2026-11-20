#!/usr/bin/env bash
# Modul 5: Fehlkonfigurationen am eigenen Webdienst finden: nmap-Skripte der Kategorie "safe" und eine eigene Checkliste. Nur Loopback-Labor.
. "$(dirname "$0")/../lab.sh"
lab_up
step "1. nmap-Skripte (lesend): Titel, Server-Kopfzeile, Methoden, robots.txt"
cmd nm -sT -p 8080 --script http-title,http-server-header,http-methods,http-robots.txt 127.0.0.1
step "2. Sicherheits-Kopfzeilen: nmap-Skript http-security-headers"
cmd nm -sT -p 8080 --script http-security-headers 127.0.0.1
echo "Das Skript gab hier nichts aus. Deutung (Fachwissen, nicht gegen die Dokumentation geprüft): Es listet nur vorhandene Kopfzeilen; die eigene Checkliste in Schritt 3 zeigt, was fehlt."
step "3. Eigene Checkliste (Kopfzeilen, Methoden, Server-Angabe)"
H=$(curl -sI 127.0.0.1:$APP/ | tr -d '\r')
pruefe() { if echo "$H" | grep -qi "^$1:"; then echo "vorhanden  $1"; else echo "FEHLT      $1"; fi; }
for k in X-Content-Type-Options X-Frame-Options Content-Security-Policy Strict-Transport-Security Referrer-Policy; do pruefe $k; done
echo "Server-Kopfzeile nennt Produkt: $(echo "$H" | grep -qi '^server:.*/' && echo ja || echo nein)"
echo "TRACE erlaubt laut OPTIONS: $(curl -s -i -X OPTIONS 127.0.0.1:$APP/ | tr -d '\r' | grep -i '^allow:' | grep -q TRACE && echo ja || echo nein)"
step "4. Verbose-Fehlerseite: nennt Pfade und Datenbank"
cmd curl -s 127.0.0.1:$APP/fehler
step "5. Vergleich mit dem zweiten Dienst (Port $APP2): gleiche Prüfung der Server-Kopfzeile"
echo "Server: $(curl -sI 127.0.0.1:$APP2/ | tr -d '\r' | awk -F': ' 'tolower($1)=="server" {print $2}')"
step "6. Was nmap-Skripte nicht ersetzen"
echo "Skripte der Kategorie safe lesen nur; sie finden keine fachlichen Fehler der Anwendung. Prüfen Sie vor jedem Skript, was es tut (Quelltext und Kategorie)."
cmd grep -m1 -n "categories" /usr/share/nmap/scripts/http-methods.nse
