#!/usr/bin/env bash
# Modul 8: Betrieb und Auswertung (stats.log, eve.json-Bericht, Abschlussprojekt mit eigenem Regelsatz).
. "$(dirname "$0")/../lab.sh"
D=$(cd "$(dirname "$0")" && pwd)
lab_up; mkpcap m8 >/dev/null
step "1. Regelsatz des Abschlussprojekts"
grep -v '^#' "$D/projekt.rules" | sed -E 's/ \(msg:/\n    (msg:/'
step "2. Lauf und Kennzahlen aus stats.log"
suri "$D/projekt.rules" "$W/m8.pcap" "$W/log"
grep -E "^(capture.kernel_packets|decoder.pkts|decoder.bytes|flow.total|detect.alert|app_layer.flow.http|app_layer.flow.dns_udp|app_layer.flow.tls) " "$W/log/stats.log" | awk '{printf "%-28s %s\n", $1, $NF}' | sort -u
step "3. Bericht: Meldungen je Regel und je Priorität"
python3 - "$W/log/eve.json" <<'PY'
import json, sys, collections
r = collections.Counter(); p = collections.Counter()
for l in open(sys.argv[1]):
    e = json.loads(l)
    if e["event_type"] == "alert":
        a = e["alert"]; r[(a["signature_id"], a["signature"])] += 1; p[a["severity"]] += 1
for (s, m), n in sorted(r.items()): print(f"{s}  {n:>2} x  {m}")
print("je Schweregrad:", dict(sorted(p.items())))
PY
step "4. Dauer eines Laufs"
S=$(date +%s.%N); suri "$D/projekt.rules" "$W/m8.pcap" "$W/log2"; E=$(date +%s.%N)
python3 -c "print('Dauer unter 5 Sekunden:', $E - $S < 5)"
step "5. Protokolldatei suricata.log: Warnungen und Fehler"
echo "Zeilen mit E: oder W: $(grep -cE '^[0-9/]+ -- .*<(Error|Warning)>' "$W/log/suricata.log")"
lab_down
