#!/usr/bin/env bash
# Modul 1: Suricata im Überblick (Version, Übersetzungsoptionen, Konfigurationstest, erster Lauf, Ausgabedateien).
. "$(dirname "$0")/../lab.sh"
lab_up
step "1. Version und Fähigkeiten"
suricata -V
suricata --build-info | grep -E "^(Features|AF_PACKET|NFQueue|libnet|Rust support|Netmap)" | sed -E 's/ +/ /g'
step "2. Konfigurationsdatei prüfen (-T)"
suricata -T -c /etc/suricata/suricata.yaml -S /dev/null >"$W/t.out" 2>&1; echo "Rückgabecode: $?"; tail -1 "$W/t.out" | sed -E 's/^[^ ]+ - <[^>]+> - //'
step "3. Verkehr erzeugen und mitschneiden"
mkpcap erste
step "4. Eine Regel und der erste Lauf im Offline-Modus"
echo 'alert http any any -> any any (msg:"LAB Zugriff auf /geheim"; flow:established,to_server; http.uri; content:"/geheim"; startswith; sid:1000001; rev:1;)' > "$W/r.rules"
suri "$W/r.rules" "$W/erste.pcap" "$W/log"
ls "$W/log" | sort | tr '\n' ' '; echo
step "5. fast.log (kurze Meldung je Treffer)"
fastlog "$W/log"
step "6. eve.json: Ereignisarten und Anzahl"
python3 - "$W/log/eve.json" <<'PY'
import json, sys, collections
c = collections.Counter(json.loads(l)["event_type"] for l in open(sys.argv[1]))
for k, v in sorted(c.items()): print(f"{k:<10} {v}")
PY
step "7. Meldung in eve.json (ausgewählte Felder)"
python3 - "$W/log/eve.json" <<'PY'
import json, sys
for l in open(sys.argv[1]):
    e = json.loads(l)
    if e["event_type"] == "alert":
        a = e["alert"]; print({"signature_id": a["signature_id"], "signature": a["signature"], "action": a["action"], "app_proto": e.get("app_proto"), "uri": e.get("http", {}).get("url")})
PY
lab_down
