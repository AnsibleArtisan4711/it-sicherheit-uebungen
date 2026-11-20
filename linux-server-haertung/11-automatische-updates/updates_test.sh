#!/usr/bin/env bash
# Prüft und konfiguriert automatische Sicherheitsupdates (unattended-upgrades): wirksame Einstellungen, eigene Konfigurationsdatei, Probelauf.
# Benötigt: unattended-upgrades, apt, root, Internetzugang zu den Paketquellen (Internetphase des Labors). Es wird nichts installiert (--dry-run, -s).
set -u
. "$(dirname "$0")/../lab.sh"
F=/etc/apt/apt.conf.d/52-p14-haertung; trap 'rm -f $F' EXIT; rm -f $F
UU=$(command -v unattended-upgrade); PY=/usr/bin/python3; [ -x /usr/bin/python3.12 ] && PY=/usr/bin/python3.12   # apt_pkg des Systems
step "1. Version und Ausgangseinstellungen"
dpkg -l unattended-upgrades | awk '/^ii/ {print $2, $3}'
echo '$ cat /etc/apt/apt.conf.d/20auto-upgrades'; grep -vE '^\s*(//|$)' /etc/apt/apt.conf.d/20auto-upgrades
echo '$ apt-config dump | grep -E "Periodic|Unattended-Upgrade::(Automatic-Reboot|Remove|Mail)"'; apt-config dump | grep -E 'APT::Periodic::|Unattended-Upgrade::(Automatic-Reboot|Remove-Unused|Mail)' | sort
step "2. Erlaubte Herkünfte (nur Sicherheitsupdates der Distribution)"
apt-config dump | grep -E 'Unattended-Upgrade::Allowed-Origins::' | sed -E 's/Unattended-Upgrade::Allowed-Origins:: //'
step "3. Eigene Einstellungen als Zusatzdatei $F"
cat > $F <<'EOF'
// Automatische Updates (Kurs P14): nur Sicherheitsupdates, nicht benötigte Pakete entfernen, kein automatischer Neustart
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "7";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Automatic-Reboot "false";
Unattended-Upgrade::Mail "root";
Unattended-Upgrade::MailReport "on-change";
EOF
cat $F | grep -v '^//'
echo; echo '$ apt-config dump | grep -E "Remove-Unused|Automatic-Reboot|MailReport"'; apt-config dump | grep -E 'Remove-Unused|Automatic-Reboot|MailReport' | sort
step "4. Simulation: was würde installiert? (apt-get -s dist-upgrade, Zahl der Pakete)"
echo "Pakete zur Aktualisierung (Simulation): $(apt-get -s dist-upgrade 2>/dev/null | grep -c '^Inst')"
apt-mark showhold | wc -l | sed 's/^/Pakete mit Haltemarkierung (apt-mark hold): /'
step "5. Probelauf von unattended-upgrade (--dry-run, dauert etwa eine Minute)"
$PY $UU --dry-run >/dev/null 2>&1; echo "Rückgabewert: $?"
L=/var/log/unattended-upgrades/unattended-upgrades.log
grep -E 'Starting unattended upgrades script|Allowed origins are|Initial blacklist|No packages found that can be upgraded unattended|Packages that will be upgraded|All upgrades installed' $L | tail -6 | sed -E 's/^[0-9-]+ [0-9:,]+ //; s/(Packages that will be upgraded:)(.*)/\1 (\2)/' | awk '/Packages that will be upgraded:/ {n=split($0,a," "); print "INFO Packages that will be upgraded: " n-6 " Pakete (Namen weggelassen)"; next} {print}'
step "6. Hinweis zu Neustarts: needrestart (nur Anzeige)"
command -v needrestart >/dev/null && needrestart -b 2>/dev/null | head -4 || echo "needrestart nicht installiert"
