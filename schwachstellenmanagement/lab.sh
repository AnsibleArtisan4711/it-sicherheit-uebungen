#!/usr/bin/env bash
# lab.sh – Hilfsfunktionen und kleines Labor für die Skripte der Übungsreihe P15
#
#   sc (10.15.0.2/24, Scanner) --- lx (10.15.0.11/24, Linux-Ziel)       zwei Netzwerk-Namespaces
#
# Nutzung:  . "$(dirname "$0")/../lab.sh"; lab_up ... lab_down
# Nur im Testlabor als root ausführen. Gescannt werden ausschließlich die Adressen dieses Labors (10.15.0.0/24).
# Das Ziel `lx` kann in zwei Zuständen gestartet werden: ziel_vorher (absichtlich schwach konfiguriert) und ziel_nachher (gehärtet).

P=p15
W=/tmp/p15-ziel
on() { local ns=$1; shift; ip netns exec "$P-$ns" "$@"; }
cmd() { echo "\$ $*"; "$@" 2>&1; return $?; }
step() { echo; echo "## $*"; }

lab_down() {
  { for n in sc lx; do ip netns pids "$P-$n" 2>/dev/null | xargs -r kill >/dev/null 2>&1; ip netns del "$P-$n" 2>/dev/null; done; } 2>/dev/null
  wait 2>/dev/null; rm -rf $W; return 0
}

lab_up() {
  lab_down; mkdir -p $W /run/sshd
  for n in sc lx; do ip netns add "$P-$n"; on $n ip link set lo up; done
  ip link add v-sc type veth peer name v-lx; ip link set v-sc netns $P-sc; ip link set v-lx netns $P-lx
  on sc ip addr add 10.15.0.2/24 dev v-sc;  on sc ip link set v-sc up
  on lx ip addr add 10.15.0.11/24 dev v-lx; on lx ip link set v-lx up
}

# --- Zielsystem vorbereiten: Zertifikat, Webseiten, Test-Konto für SSH
ziel_basis() {
  openssl req -x509 -newkey rsa:2048 -nodes -keyout $W/key.pem -out $W/cert.pem -days 30 -subj "/CN=ziel01.example.internal" >/dev/null 2>&1
  mkdir -p $W/www $W/nginx-tmp; echo "Intranet Startseite" > $W/www/index.html
  rm -f $W/hostkey $W/hostkey.pub; ssh-keygen -q -t ed25519 -N "" -f $W/hostkey
  # OpenSSL-Konfiguration, die für den Test-nginx alte Protokolle und Chiffren zulässt (nur im Testlabor, nur für diesen Prozess)
  cat > $W/openssl-alt.cnf <<'EOF'
openssl_conf = default_conf
[default_conf]
ssl_conf = ssl_sect
[ssl_sect]
system_default = system_default_sect
[system_default_sect]
MinProtocol = TLSv1
CipherString = ALL:@SECLEVEL=0
EOF
}

# nginx_start <protokolle> <chiffren> <header-ja|nein>
nginx_start() {
  local prot=$1 ciph=$2 hdr=$3 hd=""
  [ "$hdr" = ja ] && hd='add_header Strict-Transport-Security "max-age=31536000" always; add_header X-Content-Type-Options nosniff always; add_header X-Frame-Options DENY always;'
  cat > $W/nginx.conf <<EOF
daemon off; pid $W/nginx.pid; error_log $W/nginx-error.log;
events {}
http {
  access_log off; client_body_temp_path $W/nginx-tmp; proxy_temp_path $W/nginx-tmp; fastcgi_temp_path $W/nginx-tmp; uwsgi_temp_path $W/nginx-tmp; scgi_temp_path $W/nginx-tmp;
  server { listen 80; location / { root $W/www; $hd } }
  server { listen 443 ssl; ssl_certificate $W/cert.pem; ssl_certificate_key $W/key.pem;
           ssl_protocols $prot; ssl_ciphers '$ciph';
           location / { root $W/www; $hd } }
}
EOF
  ( OPENSSL_CONF=$W/openssl-alt.cnf setsid ip netns exec $P-lx nginx -c $W/nginx.conf >/dev/null 2>&1 < /dev/null & )
}

sshd_start() {   # sshd_start <konfigurationsdatei>
  ( setsid ip netns exec $P-lx /usr/sbin/sshd -f "$1" -E $W/sshd.log >/dev/null 2>&1 < /dev/null & )
}

ziel_vorher() {   # absichtlich schwach: alte TLS-Protokolle, schwache Chiffren, keine Header, SSH mit Passwort und Root, Dateiliste, Telnet-ähnlicher Dienst
  ziel_basis
  cat > $W/sshd_vorher.conf <<EOF
Port 22
HostKey $W/hostkey
PidFile $W/sshd.pid
PermitRootLogin yes
PasswordAuthentication yes
EOF
  nginx_start 'TLSv1 TLSv1.1 TLSv1.2' 'ALL:@SECLEVEL=0' nein
  sshd_start $W/sshd_vorher.conf
  mkdir -p $W/dateien; echo "-- Sicherung (Beispiel)" > $W/dateien/datenbank-sicherung.sql
  ( cd $W/dateien && setsid ip netns exec $P-lx python3 -m http.server 8080 --bind 0.0.0.0 >/dev/null 2>&1 < /dev/null & )
  printf '#!/bin/sh\nprintf "Willkommen auf ziel01 (Test-Telnet)\\r\\nlogin: "\nsleep 1\n' > $W/banner.sh; chmod +x $W/banner.sh
  ( setsid ip netns exec $P-lx socat TCP-LISTEN:2323,fork,reuseaddr EXEC:$W/banner.sh >/dev/null 2>&1 < /dev/null & )
  sleep 1.2
}

ziel_teilweise() {  # nur TLS gehärtet; SSH mit Passwort, Dateiliste und Klartextdienst bleiben (für die Gegenprobe)
  ziel_basis
  printf 'Port 22\nHostKey %s/hostkey\nPidFile %s/sshd.pid\nPermitRootLogin yes\nPasswordAuthentication yes\n' $W $W > $W/sshd_vorher.conf
  nginx_start 'TLSv1.2 TLSv1.3' 'ECDHE+AESGCM:ECDHE+CHACHA20' ja
  sshd_start $W/sshd_vorher.conf
  mkdir -p $W/dateien; echo "-- Sicherung (Beispiel)" > $W/dateien/datenbank-sicherung.sql
  ( cd $W/dateien && setsid ip netns exec $P-lx python3 -m http.server 8080 --bind 0.0.0.0 >/dev/null 2>&1 < /dev/null & )
  printf '#!/bin/sh\nprintf "Willkommen auf ziel01 (Test-Telnet)\\r\\nlogin: "\nsleep 1\n' > $W/banner.sh; chmod +x $W/banner.sh
  ( setsid ip netns exec $P-lx socat TCP-LISTEN:2323,fork,reuseaddr EXEC:$W/banner.sh >/dev/null 2>&1 < /dev/null & )
  sleep 1.2
}

ziel_nachher() {  # gehärtet: nur TLS 1.2/1.3 mit guten Chiffren, Header, SSH nur mit Schlüssel, Dateiliste und Telnet-Dienst entfernt
  ziel_basis
  cat > $W/sshd_nachher.conf <<EOF
Port 22
HostKey $W/hostkey
PidFile $W/sshd.pid
PermitRootLogin no
PasswordAuthentication no
KbdInteractiveAuthentication no
KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,sntrup761x25519-sha512@openssh.com
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com
EOF
  nginx_start 'TLSv1.2 TLSv1.3' 'ECDHE+AESGCM:ECDHE+CHACHA20' ja
  sshd_start $W/sshd_nachher.conf
  sleep 1.2
}

ziel_stop() { bash -c "ip netns pids $P-lx | xargs -r kill" >/dev/null 2>&1; sleep 1.5; return 0; }

# scan_befunde <Ziel> <CSV-Datei>: Nmap mit Skripten ausführen und Befunde (04/nmap_befunde.py) in eine CSV-Datei schreiben
scan_befunde() {
  local d; d=$(dirname "${BASH_SOURCE[0]}")
  mkdir -p $W
  on sc nmap -n -Pn -sV --version-light --script ssl-enum-ciphers,ssh-auth-methods,http-title,http-headers,banner -p 22,80,443,2323,8080 "$1" -oX $W/scan.xml >/dev/null 2>&1
  python3 "$(ls -d $d/04*/ | head -1)nmap_befunde.py" $W/scan.xml > "$2"
}
