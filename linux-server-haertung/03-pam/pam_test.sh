#!/usr/bin/env bash
# Testet Passwortqualität (pam_pwquality/pwscore) und Kontosperre (pam_faillock) mit einem eigenen PAM-Dienst.
# Benötigt: libpam-pwquality, libpwquality-tools (pwscore, pwmake), pamtester, root.
# Legt das Konto p14test und die PAM-Datei /etc/pam.d/p14-test an und entfernt beides am Ende wieder.
set -u
. "$(dirname "$0")/../lab.sh"
useradd -m -s /bin/bash p14test; echo 'p14test:Richtig-123-Passwort' | chpasswd
mkdir -p /etc/security; cp /etc/security/faillock.conf /tmp/p14-faillock.conf.bak 2>/dev/null
mkdir -p /etc/security/pwquality.conf.d
cat > /etc/security/pwquality.conf.d/p14.conf <<'EOF'
minlen = 12
minclass = 3
maxrepeat = 2
dictcheck = 1
usercheck = 1
EOF
step "1. Passwortqualität: pwscore mit der Konfiguration (minlen 12, 3 Zeichenklassen)"
for pw in 'kurz1A' 'passwortpasswort' 'Sommer2026' 'Kohl-Rabe-7-Treppe!' 'aaaBBB111!!!xyz'; do
  printf '%-22s -> ' "$pw"; echo "$pw" | pwscore 2>&1 | tail -1 | sed 's/^ *//'; done
echo; echo "(Konfiguration im Test: /etc/security/pwquality.conf.d/p14.conf; Ergebnis = Punktzahl 0 bis 100, sonst Fehlermeldung)"
step "2. Dasselbe ohne eigene Konfiguration (nur Vorgaben des Programms)"
mv /etc/security/pwquality.conf.d/p14.conf /tmp/p14-pwq.conf
for pw in 'kurz1A' 'Sommer2026'; do printf '%-22s -> ' "$pw"; echo "$pw" | pwscore 2>&1 | tail -1 | sed 's/^ *//'; done
step "3. pwmake erzeugt ein Passwort mit 80 Bit Entropie"
pwmake 80 | awk '{print "Länge:", length($0)}'
step "4. Kontosperre mit pam_faillock (3 Fehlversuche, 60 s Sperre)"
cat > /etc/pam.d/p14-test <<'EOF'
auth     required   pam_faillock.so preauth silent audit deny=3 unlock_time=60 dir=/tmp/p14-faillock
auth     [success=1 default=bad] pam_unix.so
auth     [default=die] pam_faillock.so authfail audit deny=3 unlock_time=60 dir=/tmp/p14-faillock
auth     sufficient pam_faillock.so authsucc audit deny=3 unlock_time=60 dir=/tmp/p14-faillock
account  required   pam_unix.so
EOF
mkdir -p /tmp/p14-faillock
try() { printf '%s\n' "$1" | pamtester p14-test p14test authenticate >/dev/null 2>&1 && echo "Versuch mit '$2': ERFOLG" || echo "Versuch mit '$2': abgelehnt"; }
try 'falsch1' falsch1; try 'falsch2' falsch2; try 'falsch3' falsch3
try 'Richtig-123-Passwort' 'richtiges Passwort (nach 3 Fehlversuchen)'
echo; echo "\$ faillock --dir /tmp/p14-faillock --user p14test"; faillock --dir /tmp/p14-faillock --user p14test
echo; echo "\$ faillock --dir /tmp/p14-faillock --user p14test --reset"; faillock --dir /tmp/p14-faillock --user p14test --reset
try 'Richtig-123-Passwort' 'richtiges Passwort (nach Entsperren)'
userdel -r p14test 2>/dev/null; rm -rf /etc/pam.d/p14-test /tmp/p14-faillock /tmp/p14-pwq.conf /etc/security/pwquality.conf.d/p14.conf
