#!/usr/bin/env bash
# Modul 2: Regeln schreiben (Aufbau, content, flow, startswith, nocase, Fehlermeldungen).
. "$(dirname "$0")/../lab.sh"
D=$(cd "$(dirname "$0")" && pwd)
lab_up; mkpcap m2 >/dev/null
step "1. Regeldatei (regeln.rules)"
grep -v '^#' "$D/regeln.rules" | sed -E 's/ \(msg:/\n    (msg:/'
step "2. Lauf"
suri "$D/regeln.rules" "$W/m2.pcap" "$W/log"
fastlog "$W/log" | sed -E 's/ \[Classification: [^]]*\] \[Priority: [0-9]\]//'
step "3. Unterschied: startswith (1000001) gegen reines content (1000002)"
python3 - "$W/log/eve.json" <<'PY'
import json, sys, collections
c = collections.Counter()
for l in open(sys.argv[1]):
    e = json.loads(l)
    if e["event_type"] == "alert": c[e["alert"]["signature_id"]] += 1
for k in sorted(c): print(f"sid {k}: {c[k]} Treffer")
PY
step "4. Regel mit Syntaxfehler (unbekanntes Schlüsselwort)"
echo 'alert http any any -> any any (msg:"kaputt"; flow:established; http.uri; inhalt:"/geheim"; sid:1000009; rev:1;)' > "$W/kaputt.rules"
suricata -T -c /etc/suricata/suricata.yaml -S "$W/kaputt.rules" 2>&1 | grep -iE "error|unknown|failed" | head -3 | sed -E 's/^[^ ]+ - <[^>]+> - //'
step "5. Regel ohne sid"
echo 'alert http any any -> any any (msg:"ohne sid"; http.uri; content:"/geheim";)' > "$W/ohnesid.rules"
suricata -T -c /etc/suricata/suricata.yaml -S "$W/ohnesid.rules" 2>&1 | grep -iE "error|sid|failed" | head -2 | sed -E 's/^[^ ]+ - <[^>]+> - //'
lab_down
