#!/usr/bin/env bash
# Gemeinsame Hilfen der Übungsreihe (P62). Nur im Testlabor ausführen.
# Es wird Verkehr über die Loopback-Schnittstelle erzeugt, mit tcpdump mitgeschnitten und mit Suricata im Offline-Modus (-r) ausgewertet.
# Es werden nur eigene Systeme angesprochen. Inline-Betrieb (IPS) wird nicht ausgeführt.
W=/tmp/p62
step() { echo; echo "## $*"; }
cmd() { echo "\$ $*"; "$@" 2>&1; return $?; }
lab_up() { lab_down >/dev/null 2>&1; mkdir -p "$W/www" "$W/log"; echo "Hallo" > "$W/www/index.html"; mkdir -p "$W/www/geheim"; echo "Plan" > "$W/www/geheim/plan.txt"; }
lab_down() { pkill -f "http.server 8080" 2>/dev/null; pkill -f "$W/dns.py" 2>/dev/null; pkill -f "openssl s_server -accept 8443" 2>/dev/null; pkill -f "tcpdump -nn -i lo -w $W" 2>/dev/null; sleep 0.3; rm -rf "$W"; }
# Verkehr erzeugen und mitschneiden: mkpcap NAME  (Ergebnis: $W/NAME.pcap)
mkpcap() {
  local n=$1
  (cd "$W/www" && python3 -m http.server 8080 --bind 127.0.0.1 >/dev/null 2>&1 &)
  cat > "$W/dns.py" <<'PY'
import socket, struct
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM); s.bind(("127.0.0.1", 53))
s.settimeout(30)
while True:
    try: d, a = s.recvfrom(512)
    except Exception: break
    q = d[12:]; i = 0
    while q[i]: i += q[i] + 1
    q = q[:i + 5]
    r = d[:2] + b"\x81\x80" + d[4:6] + b"\x00\x01\x00\x00\x00\x00" + q + b"\xc0\x0c\x00\x01\x00\x01\x00\x00\x00\x3c\x00\x04\x7f\x00\x00\x01"
    s.sendto(r, a)
PY
  python3 "$W/dns.py" >/dev/null 2>&1 &
  openssl req -x509 -newkey rsa:2048 -nodes -keyout "$W/k.pem" -out "$W/c.pem" -subj "/CN=lab.example.com" -days 1 >/dev/null 2>&1
  openssl s_server -accept 8443 -cert "$W/c.pem" -key "$W/k.pem" -www >/dev/null 2>&1 &
  sleep 1
  tcpdump -nn -i lo -w "$W/$n.pcap" -U >/dev/null 2>&1 &
  sleep 1
  curl -s -m 3 -o /dev/null http://127.0.0.1:8080/index.html
  curl -s -m 3 -o /dev/null http://127.0.0.1:8080/geheim/plan.txt
  curl -s -m 3 -o /dev/null "http://127.0.0.1:8080/index.html?pfad=/geheim"
  curl -s -m 3 -o /dev/null -A "sqlmap/1.7" http://127.0.0.1:8080/index.html
  curl -s -m 3 -o /dev/null --path-as-is "http://127.0.0.1:8080/../../etc/passwd"
  python3 - <<'PY'
import socket, struct
def q(name):
    h = b"\x12\x34\x01\x00\x00\x01\x00\x00\x00\x00\x00\x00"
    n = b"".join(bytes([len(p)]) + p.encode() for p in name.split(".")) + b"\x00"
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM); s.settimeout(2)
    s.sendto(h + n + b"\x00\x01\x00\x01", ("127.0.0.1", 53))
    try: s.recvfrom(512)
    except Exception: pass
for n in ("www.example.com", "lange-zufaellige-bezeichnung-abc123.tunnel.example.net"): q(n)
PY
  echo | openssl s_client -connect 127.0.0.1:8443 -servername shop.example.org >/dev/null 2>&1
  for p in 21 22 23 3389; do (echo > /dev/tcp/127.0.0.1/$p) 2>/dev/null; done
  sleep 1
  pkill -f "tcpdump -nn -i lo -w $W/$n.pcap" 2>/dev/null; sleep 0.5
  pkill -f "http.server 8080"; pkill -f "$W/dns.py"; pkill -f "openssl s_server -accept 8443"
  echo "Mitschnitt $n: $(tcpdump -nn -r "$W/$n.pcap" 2>/dev/null | wc -l) Pakete"
}
# Suricata offline: suri REGELDATEI PCAP LOGDIR [weitere Optionen]
suri() {
  local r=$1 p=$2 l=$3; shift 3; mkdir -p "$l"
  suricata -c /etc/suricata/suricata.yaml -S "$r" -r "$p" -l "$l" -k none --set vars.address-groups.HOME_NET="[127.0.0.0/8]" "$@" >"$l/suri.out" 2>&1
}
fastlog() { sed -E 's/^[0-9\/]+-[0-9:.]+  //' "$1/fast.log" | sed -E 's/ [0-9.]+:[0-9]+ -> / A:P -> /; s/:[0-9]+$/:P/' | sort; }
