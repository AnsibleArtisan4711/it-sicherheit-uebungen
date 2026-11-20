#!/usr/bin/env bash
# Modul 7: Regeldateien verwalten (rule-files, Prüfung mit -T, doppelte SIDs, Version rev, Regelsätze). suricata-update wird nicht ausgeführt (braucht Internet).
. "$(dirname "$0")/../lab.sh"
lab_up
step "1. Welche Regeldateien lädt die Standardkonfiguration?"
python3 - <<'PY'
import yaml
c = yaml.safe_load(open("/etc/suricata/suricata.yaml"))
print("default-rule-path:", c["default-rule-path"]); print("rule-files:", c["rule-files"])
PY
ls /etc/suricata/rules 2>/dev/null | head; echo "Dateien in /etc/suricata/rules: $(ls /etc/suricata/rules 2>/dev/null | wc -l)"
step "2. Zwei eigene Regeldateien anlegen (lokal.rules, intern.rules)"
cat > "$W/lokal.rules" <<'R'
alert http any any -> any any (msg:"LAB geheim"; flow:established,to_server; http.uri; content:"/geheim"; startswith; sid:1000701; rev:1;)
alert dns any any -> any any (msg:"LAB tunnel"; dns.query; content:"tunnel"; sid:1000702; rev:1;)
R
cat > "$W/intern.rules" <<'R'
alert http any any -> any any (msg:"LAB geheim (zweite Fassung)"; flow:established,to_server; http.uri; content:"/geheim"; sid:1000701; rev:2;)
alert tcp any any -> any 22 (msg:"LAB ssh"; flags:S,12; sid:1000703; rev:1;)
R
echo "lokal.rules: $(grep -c . "$W/lokal.rules") Regeln, intern.rules: $(grep -c . "$W/intern.rules") Regeln"
step "3. Doppelte SIDs über alle Dateien finden"
python3 - "$W" <<'PY'
import re, sys, collections, glob
d = collections.defaultdict(list)
for f in sorted(glob.glob(sys.argv[1] + "/*.rules")):
    for z in open(f):
        m = re.search(r"sid:(\d+);\s*rev:(\d+)", z)
        if m: d[m.group(1)].append((f.rsplit("/", 1)[1], m.group(2)))
for sid, v in sorted(d.items()):
    print(sid, v, "<- DOPPELT" if len(v) > 1 else "")
PY
step "4. Laden mit zwei Dateien (-T) und mit doppelter SID"
cp /etc/suricata/suricata.yaml "$W/s.yaml"
python3 - "$W" <<'PY'
import yaml, sys
p = sys.argv[1]
c = yaml.safe_load(open(p + "/s.yaml")); c["default-rule-path"] = p; c["rule-files"] = ["lokal.rules", "intern.rules"]
open(p + "/s2.yaml", "w").write("%YAML 1.1\n---\n" + yaml.safe_dump(c))
PY
suricata -T -c "$W/s2.yaml" 2>&1 | grep -E "rules successfully|duplicate|error|E:|W:|Configuration provided" | sed -E 's/^[^ ]+ - <[^>]+> - //' | head -5
step "5. Eine Regel ändern: rev erhöhen"
echo "vorher: $(grep -o 'sid:1000701; rev:[0-9]*' "$W/lokal.rules")"
sed -i 's/sid:1000701; rev:1;/sid:1000701; rev:3;/' "$W/lokal.rules"
echo "nachher: $(grep -o 'sid:1000701; rev:[0-9]*' "$W/lokal.rules")"
lab_down
