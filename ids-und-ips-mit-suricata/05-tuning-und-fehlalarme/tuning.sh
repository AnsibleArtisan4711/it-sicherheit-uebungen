#!/usr/bin/env bash
# Modul 5: Fehlalarme und Lautstärke (threshold in der Regel, suppress und threshold-Datei, pass-Regel, Regel abschalten).
. "$(dirname "$0")/../lab.sh"
D=$(cd "$(dirname "$0")" && pwd)
lab_up; mkpcap m5 >/dev/null
anz() { python3 - "$1" <<'PY'
import json, sys, collections
c = collections.Counter()
for l in open(sys.argv[1] + "/eve.json"):
    e = json.loads(l)
    if e["event_type"] == "alert": c[e["alert"]["signature_id"]] += 1
print("  ".join(f"{k}:{v}" for k, v in sorted(c.items())) or "keine Meldungen")
PY
}
step "1. Ausgangslage: Meldungen je Regel (sid:Anzahl)"
suri "$D/tuning.rules" "$W/m5.pcap" "$W/l1"; anz "$W/l1"
step "2. Begrenzung in der Regel: sid 1000503 (limit 2) gegen sid 1000502 (ohne Begrenzung)"
echo "Regel 1000502: $(python3 -c "import json;print(sum(1 for l in open('$W/l1/eve.json') if json.loads(l)['event_type']=='alert' and json.loads(l)['alert']['signature_id']==1000502))") Meldungen; Regel 1000503: $(python3 -c "import json;print(sum(1 for l in open('$W/l1/eve.json') if json.loads(l)['event_type']=='alert' and json.loads(l)['alert']['signature_id']==1000503))") Meldungen"
step "3. suppress in einer threshold-Datei: Regel 1000501 für das Ziel 127.0.0.1 unterdrücken (suppress kennt keine Ports)"
cat > "$W/threshold.config" <<'T'
suppress gen_id 1, sig_id 1000501, track by_dst, ip 127.0.0.1
T
cat "$W/threshold.config"
suri "$D/tuning.rules" "$W/m5.pcap" "$W/l2" --set threshold-file="$W/threshold.config"; anz "$W/l2"
step "4. pass-Regel vor allen anderen: HTTP-Verbindungen vom Alarm ausnehmen"
{ echo 'pass http any any -> any any (msg:"LAB Ausnahme 8080"; flow:established,to_server; sid:1000599; rev:1;)'; grep -v '^#' "$D/tuning.rules"; } > "$W/mit_pass.rules"
suri "$W/mit_pass.rules" "$W/m5.pcap" "$W/l3"; anz "$W/l3"
step "5. Regel abschalten: Zeile auskommentieren (sid 1000501)"
sed 's/^alert tcp any any -> \$HOME_NET any/#&/' "$D/tuning.rules" > "$W/ohne501.rules"
suri "$W/ohne501.rules" "$W/m5.pcap" "$W/l4"; anz "$W/l4"
lab_down
