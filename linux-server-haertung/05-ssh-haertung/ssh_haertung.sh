#!/usr/bin/env bash
# Härtet einen sshd (Port 2222 im Namespace "srv"), testet Anmeldungen aus dem Namespace "cl" und bewertet die Konfiguration mit ssh-audit.
# Benötigt: openssh-server, openssh-client, ssh-audit (pip), ip, root. Legt die Konten t14ssh und t14fremd an und entfernt alles am Ende wieder.
set -u
. "$(dirname "$0")/../lab.sh"
W=/tmp/p14-ssh; cleanup() { lab_down; userdel -r t14ssh >/dev/null 2>&1; userdel -r t14fremd >/dev/null 2>&1; groupdel t14sshgrp >/dev/null 2>&1; rm -rf $W; }
trap cleanup EXIT; cleanup; mkdir -p $W /run/sshd; lab_up
groupadd t14sshgrp; useradd -m -s /bin/bash -G t14sshgrp t14ssh; useradd -m -s /bin/bash t14fremd
usermod -p '*' t14ssh; usermod -p '*' t14fremd;
ssh-keygen -q -t ed25519 -N '' -f $W/hostkey_ed25519
ssh-keygen -q -t ed25519 -N '' -f $W/client_key
for u in t14ssh t14fremd; do install -d -m 700 -o $u -g $u /home/$u/.ssh; install -m 600 -o $u -g $u $W/client_key.pub /home/$u/.ssh/authorized_keys; done
SSH="ssh -p 2222 -i $W/client_key -o IdentitiesOnly=yes -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectTimeout=5 -o LogLevel=ERROR"

cat > $W/sshd_standard.conf <<EOF
# Ausgangszustand: fast alle Vorgaben des Pakets, nur Port, Hostschlüssel und PID-Datei angepasst
Port 2222
HostKey $W/hostkey_ed25519
PidFile $W/sshd.pid
PermitRootLogin yes
PasswordAuthentication yes
EOF
cat > $W/sshd_gehaertet.conf <<EOF
# Gehärtete Konfiguration (Auszug), Port, Hostschlüssel und PID-Datei nur wegen des Testlabors
Port 2222
HostKey $W/hostkey_ed25519
PidFile $W/sshd.pid
Protocol 2
PermitRootLogin no
PasswordAuthentication no
KbdInteractiveAuthentication no
PubkeyAuthentication yes
AuthenticationMethods publickey
AllowGroups t14sshgrp
MaxAuthTries 3
LoginGraceTime 20
MaxSessions 4
ClientAliveInterval 300
ClientAliveCountMax 2
X11Forwarding no
AllowTcpForwarding no
AllowAgentForwarding no
PermitEmptyPasswords no
PermitUserEnvironment no
LogLevel VERBOSE
KexAlgorithms sntrup761x25519-sha512@openssh.com,curve25519-sha256,curve25519-sha256@libssh.org
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com
HostKeyAlgorithms ssh-ed25519
Banner none
EOF
start() { on srv /usr/sbin/sshd -f "$1" -E $W/sshd.log; sleep 0.8; }
stop()  { [ -f $W/sshd.pid ] && kill "$(cat $W/sshd.pid)" 2>/dev/null; sleep 0.5; rm -f $W/sshd.pid; }
audit() { on cl ssh-audit -n --skip-rate-test -p 2222 10.14.0.1 2>&1 | sed -E 's/\x1b\[[0-9;]*m//g' > $W/audit.txt
  echo "Anzahl [fail]: $(grep -c '\[fail\]' $W/audit.txt)   Anzahl [warn]: $(grep -c '\[warn\]' $W/audit.txt)"
  grep '\[fail\]' $W/audit.txt | sed -E 's/ +/ /g' | cut -c1-120 | head -${1:-8}; }
v() { pip show ssh-audit 2>/dev/null | sed -n '1,2p' | tr '\n' ' '; echo; }

step "Werkzeuge"; sshd -V 2>&1 | head -1; v
step "1. Konfiguration prüfen: sshd -t und wirksame Werte mit sshd -T"
cmd sshd -t -f $W/sshd_gehaertet.conf; echo "Rückgabewert sshd -t: $?"
echo '$ sshd -T -f gehaertet | grep -E "^(permitrootlogin|passwordauthentication|allowgroups|maxauthtries|x11forwarding|allowtcpforwarding)"'
sshd -T -f $W/sshd_gehaertet.conf | grep -E '^(permitrootlogin|passwordauthentication|allowgroups|maxauthtries|x11forwarding|allowtcpforwarding) '
echo; echo '$ sshd -t mit absichtlichem Tippfehler (PermitRotLogin)'; printf 'PermitRotLogin no\n' > $W/falsch.conf; sshd -t -f $W/falsch.conf; echo "Rückgabewert: $?"

step "2. Ausgangszustand: Anmeldungen mit Passwort und als root"
start $W/sshd_standard.conf
echo '$ ssh -p 2222 -o PreferredAuthentications=password root@10.14.0.1  (Passwortanmeldung als root, Vorgabe)'
on cl $SSH -o PreferredAuthentications=password -o BatchMode=yes root@10.14.0.1 true 2>&1 | head -1
echo "(BatchMode verhindert die Passwortabfrage; 'Permission denied (publickey,password...)' zeigt, dass Passwortanmeldung angeboten wird)"
step "3. ssh-audit gegen den Ausgangszustand (Zahl der Fehler und Warnungen, Auszug der Fehler)"
audit 8; stop

step "4. Gehärteter sshd: Anmeldungen"
start $W/sshd_gehaertet.conf
echo '$ ssh t14ssh@10.14.0.1 hostname   (Schlüssel, Gruppe t14sshgrp: erlaubt)'; on cl $SSH t14ssh@10.14.0.1 'echo angemeldet als $(id -un)' 2>&1
echo '$ ssh t14fremd@10.14.0.1 hostname (Schlüssel, aber nicht in AllowGroups)'; on cl $SSH -o BatchMode=yes t14fremd@10.14.0.1 true 2>&1 | head -1
echo '$ ssh root@10.14.0.1 (PermitRootLogin no)'; on cl $SSH -o BatchMode=yes root@10.14.0.1 true 2>&1 | head -1
echo '$ ssh -o PreferredAuthentications=password t14ssh@10.14.0.1'; on cl $SSH -o PreferredAuthentications=password -o BatchMode=yes t14ssh@10.14.0.1 true 2>&1 | head -1
echo '$ ssh -f -N -L 8080:127.0.0.1:80 t14ssh@10.14.0.1; curl http://127.0.0.1:8080/   (AllowTcpForwarding no)'
mkdir -p /tmp/p14-www; echo ok > /tmp/p14-www/index.html; ( cd /tmp/p14-www && setsid ip netns exec p14-srv python3 -m http.server 80 --bind 127.0.0.1 >/dev/null 2>&1 < /dev/null & ); sleep 0.6
on cl $SSH -f -N -L 8080:127.0.0.1:80 t14ssh@10.14.0.1 2>$W/client_fwd.log; sleep 0.5
on cl curl -s -m 3 http://127.0.0.1:8080/ ; echo "curl Rückgabewert: $?"; sleep 0.5; grep -m1 -o 'channel [0-9]*: open failed: administratively prohibited.*' $W/client_fwd.log | sed -E 's/channel [0-9]+/channel N/'
rm -rf /tmp/p14-www
step "5. Protokoll des Servers (VERBOSE, Auszug; Zeit, Prozessnummer und Port weggelassen)"
grep -E 'Accepted|Failed|not allowed|Invalid|refused|forwarding' $W/sshd.log | sed -E 's/^.*sshd(\[[0-9]+\])?: //; s/ port [0-9]+//; s/SHA256:[A-Za-z0-9+\/]+/SHA256:…/' | sort | uniq -c | sort -rn | head -10
step "6. ssh-audit gegen die gehärtete Konfiguration (gleiche Auswertung)"
audit 8
stop
