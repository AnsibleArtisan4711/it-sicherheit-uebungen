#!/usr/bin/env bash
# Modul 3: Mitschnitte offline analysieren (tcpdump-Zusammenfassung, Suricata-Lauf, Flows, Wiederholbarkeit).
. "$(dirname "$0")/../lab.sh"
D=$(cd "$(dirname "$0")" && pwd)
R2=$(ls "$D"/../02*/regeln.rules)
lab_up; mkpcap m3 >/dev/null
step "1. Der Mitschnitt in Zahlen (tcpdump)"
echo "Pakete insgesamt: $(tcpdump -nn -r "$W/m3.pcap" 2>/dev/null | wc -l)"
for p in 8080 53 8443 22; do echo "Pakete mit Port $p: $(tcpdump -nn -r "$W/m3.pcap" "port $p" 2>/dev/null | wc -l)"; done
step "2. Suricata auf dem Mitschnitt (Regeln aus Modul 2)"
suri "$R2" "$W/m3.pcap" "$W/log"
grep -E "read 1 file" "$W/log/suri.out" | sed -E 's/^[^ ]+ - <[^>]+> - //'
echo "Meldungen: $(wc -l < "$W/log/fast.log")"
step "3. Flows aus eve.json (Anwendungsprotokoll, Zustand, Pakete)"
python3 - "$W/log/eve.json" <<'PY'
import json, sys
z = []
for l in open(sys.argv[1]):
    e = json.loads(l)
    if e["event_type"] == "flow":
        f = e["flow"]
        z.append((e.get("app_proto", "-"), e["proto"], e["dest_port"], f["state"], f["pkts_toserver"] + f["pkts_toclient"]))
for r in sorted(z, key=lambda r: (r[2], r[0])): print("%-8s %-4s Zielport %-5s %-12s %s Pakete" % r)
PY
step "4. Gleicher Mitschnitt, zweiter Lauf: gleiche Meldungen?"
suri "$R2" "$W/m3.pcap" "$W/log2"
diff <(fastlog "$W/log") <(fastlog "$W/log2") >/dev/null && echo "ja, identisch" || echo "nein, Unterschiede"
step "5. Ohne Regeln: nur Protokolleinträge, keine Meldungen"
: > "$W/leer.rules"; suri "$W/leer.rules" "$W/m3.pcap" "$W/log3"
echo "Meldungen: $(wc -l < "$W/log3/fast.log"), Protokolleinträge in eve.json: $(grep -c . "$W/log3/eve.json")"
lab_down
