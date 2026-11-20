#!/usr/bin/env bash
# Modul 4: Portscans mit nmap gegen das eigene Loopback-Labor (127.0.0.1). Nur Verbindungsscan (-sT), keine Rechte nötig.
. "$(dirname "$0")/../lab.sh"
lab_up
step "1. Einzelne Ports: offen und geschlossen"
cmd nm -sT -p 2121,2222,8080,8081,9999 127.0.0.1
step "2. Grund der Einstufung (--reason)"
cmd nm -sT -p 8080,9999 --reason 127.0.0.1
step "3. Portbereich 8000-8100 (nur offene Ports anzeigen)"
cmd nm -sT -p 8000-8100 --open 127.0.0.1
step "4. Grepbarer Export und Auswertung (offene Ports)"
nmap -sT -p 2000-9000 --open -oG "$W/scan.gnmap" 127.0.0.1 >/dev/null 2>&1
grep -o '[0-9]*/open/tcp//[^/]*' "$W/scan.gnmap" | sed 's|/open/tcp//| |' | grep -E '^(2121|2222|8080|8081) '
echo "Labor-Ports gefunden: $(grep -o '[0-9]*/open/tcp' "$W/scan.gnmap" | grep -cE '^(2121|2222|8080|8081)/')"
echo "Weitere offene Ports im Bereich gehören nicht zum Labor und werden hier nicht ausgewertet."
step "5. Dienstname aus der Portnummer ist keine Dienst-Erkennung"
cmd nm -sT -p 2121,2222 127.0.0.1
echo "Die Namen stammen aus der Portliste von nmap; der Banner (Modul 3) zeigt, dass auf 2222 kein SSH-Standardport, aber ein SSH-Banner liegt."
step "6. Mit Banner-Skript: nmap liest die Banner"
cmd nm -sT -p 2121,2222 --script banner 127.0.0.1
step "7. Hinweis zu -sV"
echo "Die Versionserkennung (-sV) dauerte im Test rund 90 Sekunden für vier Ports und wurde nicht in die Übung aufgenommen."
