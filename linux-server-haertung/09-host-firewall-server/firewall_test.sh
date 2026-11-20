#!/usr/bin/env bash
# Lädt server_firewall.nft im Namespace "srv" und prüft aus dem Namespace "cl": erlaubte und gesperrte Zugriffe, Zähler, Quelladresse.
# Benötigt: nft, nc, curl, ip, python3, root. Zweite Quelladresse 10.14.0.3 wird dem Client temporär hinzugefügt.
set -u
cd "$(dirname "$0")" || exit 1; . ../lab.sh
D=.; trap lab_down EXIT; lab_up
on cl ip addr add 10.14.0.3/24 dev v-cl
( setsid ip netns exec p14-srv python3 -m http.server 8080 --bind 0.0.0.0 >/dev/null 2>&1 < /dev/null & )
( setsid ip netns exec p14-srv nc -l -k -p 22 >/dev/null 2>&1 < /dev/null & )
( setsid ip netns exec p14-srv nc -l -k -p 3306 >/dev/null 2>&1 < /dev/null & ); sleep 0.8
t() { local src=$1 port=$2; if on cl nc -z -w1 -s "$src" 10.14.0.1 "$port" >/dev/null 2>&1; then echo "Quelle $src -> Port $port: erlaubt"; else echo "Quelle $src -> Port $port: GESPERRT"; fi; }
step "1. Ohne Firewall: alles erreichbar"
t 10.14.0.2 22; t 10.14.0.2 8080; t 10.14.0.2 3306; t 10.14.0.3 22
step "2. Regelwerk laden und prüfen (nft -c, dann Laden)"
cmd nft -c -f $D/server_firewall.nft; echo "Rückgabewert Syntaxprüfung: $?"
on srv nft -f $D/server_firewall.nft; echo "geladen"
step "3. Mit Firewall"
t 10.14.0.2 22; t 10.14.0.3 22; t 10.14.0.2 8080; t 10.14.0.3 8080; t 10.14.0.2 3306
echo; echo "Ping (zehn Pakete, schnell):"; on cl ping -q -c 10 -i 0.05 10.14.0.1 | grep -E 'packets transmitted'
step "4. Zähler: wie viele Pakete wurden verworfen? (letzte Regel mit counter)"
on srv nft list chain inet haertung eingang | grep -E 'counter packets' | sed -E 's/log prefix.*drop/…drop/'
step "5. Rate-Limit für SSH: acht schnelle Verbindungsversuche von der Verwaltungsadresse"
ok=0; for i in $(seq 1 8); do on cl nc -z -w1 -s 10.14.0.2 10.14.0.1 22 >/dev/null 2>&1 && ok=$((ok+1)); done; echo "erfolgreich: $ok von 8 (Grenze: 6 pro Minute, burst 6; vorherige Tests zählen mit)"
step "6. Sicherheitsnetz: Rückfall ohne Aussperren (Hinweis)"
echo "In der VM vor dem Laden: 'at now + 3 minutes' mit 'nft flush ruleset' vorbereiten und danach mit 'atrm' entfernen."
