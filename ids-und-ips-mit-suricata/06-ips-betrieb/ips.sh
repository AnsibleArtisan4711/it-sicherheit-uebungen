#!/usr/bin/env bash
# Modul 6 (Priorität 2): Aktionen alert, drop, reject; IPS-Betrieb nur beschrieben. Offline wird nichts verworfen.
. "$(dirname "$0")/../lab.sh"
D=$(cd "$(dirname "$0")" && pwd)
lab_up; mkpcap m6 >/dev/null
step "1. Unterstützt diese Suricata-Version den NFQ-Modus? (Übersetzungsoptionen)"
suricata --build-info | grep -oE "NFQ" | head -1
step "2. Regeln mit den Aktionen alert, drop und reject"
grep -v '^#' "$D/ips.rules" | sed -E 's/ \(msg:/\n    (msg:/'
step "3. Lauf offline (fast.log): drop und reject erscheinen mit Kennzeichen [wDrop]"
suri "$D/ips.rules" "$W/m6.pcap" "$W/log"
fastlog "$W/log" | sed -E 's/ \[Classification: [^]]*\] \[Priority: [0-9]\]//'
step "4. Aktion je Meldung in eve.json (Beobachtung dieses Laufs)"
python3 - "$W/log/eve.json" <<'PY'
import json, sys
for l in sorted(open(sys.argv[1])):
    e = json.loads(l)
    if e["event_type"] == "alert": print(e["alert"]["signature_id"], e["alert"]["action"])
PY
step "5. Hat der Lauf etwas verworfen? Der Mitschnitt ist unverändert, alle Pakete wurden gelesen"
grep -E "read 1 file" "$W/log/suri.out" | sed -E 's/^[^ ]+ - <[^>]+> - //'
lab_down
