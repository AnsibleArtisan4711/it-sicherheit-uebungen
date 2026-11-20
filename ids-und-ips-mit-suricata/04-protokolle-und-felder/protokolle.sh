#!/usr/bin/env bash
# Modul 4: Protokollfelder (dns.query, tls.sni, tls.cert_subject, http.*) und die Ereignisse in eve.json.
. "$(dirname "$0")/../lab.sh"
D=$(cd "$(dirname "$0")" && pwd)
lab_up; mkpcap m4 >/dev/null
step "1. Regeln"
grep -v '^#' "$D/protokolle.rules" | sed -E 's/ \(msg:/\n    (msg:/'
step "2. Lauf"
suri "$D/protokolle.rules" "$W/m4.pcap" "$W/log"
python3 - "$W/log/eve.json" <<'PY'
import json, sys, collections
c = collections.Counter(); 
for l in open(sys.argv[1]):
    e = json.loads(l)
    if e["event_type"] == "alert": c[(e["alert"]["signature_id"], e["alert"]["signature"])] += 1
for (s, m), n in sorted(c.items()): print(f"sid {s}: {n} x  {m}")
PY
step "3. DNS-Ereignisse (Abfragen)"
python3 - "$W/log/eve.json" <<'PY'
import json, sys
for l in open(sys.argv[1]):
    e = json.loads(l)
    if e["event_type"] == "dns" and e["dns"]["type"] == "query": print(e["dns"]["rrname"], e["dns"]["rrtype"])
PY
step "4. TLS-Ereignis (ausgewählte Felder)"
python3 - "$W/log/eve.json" <<'PY'
import json, sys
for l in open(sys.argv[1]):
    e = json.loads(l)
    if e["event_type"] == "tls": t = e["tls"]; print({"sni": t.get("sni"), "subject": t.get("subject"), "version": t.get("version")})
PY
step "5. HTTP-Ereignisse (Methode, Adresse, Statuscode, User-Agent)"
python3 - "$W/log/eve.json" <<'PY'
import json, sys
for l in open(sys.argv[1]):
    e = json.loads(l)
    if e["event_type"] == "http":
        h = e["http"]; print(h["http_method"], h["url"], h.get("status"), h.get("http_user_agent", "").split(" ")[0])
PY
lab_down
