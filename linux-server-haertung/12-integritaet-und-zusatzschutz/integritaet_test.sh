#!/usr/bin/env bash
# AIDE: Datenbank anlegen, Änderungen erkennen. fail2ban-regex: Filter gegen eine Beispiel-Protokolldatei testen.
# Benötigt: aide, fail2ban (fail2ban-regex), root. Alles läuft in /tmp/p14-aide mit eigener Konfiguration; die Systemkonfiguration von AIDE und fail2ban wird nicht verwendet.
set -u
. "$(dirname "$0")/../lab.sh"; cd "$(dirname "$0")" || exit 1; L=$PWD/beispiel_ssh.log
A=/tmp/p14-aide; trap 'rm -rf $A' EXIT; rm -rf $A; mkdir -p $A/baum/etc $A/baum/bin; echo "port=22" > $A/baum/etc/dienst.conf; echo "tool" > $A/baum/bin/tool; chmod 755 $A/baum/bin/tool
cat > $A/aide.conf <<EOF
database_in=file:$A/aide.db
database_out=file:$A/aide.db.neu
database_new=file:$A/aide.db.neu
report_url=stdout
# Regeln: p = Rechte, i = Inode, u/g = Benutzer/Gruppe, s = Größe, m = Änderungszeit, sha256 = Prüfsumme
Alles = p+i+n+u+g+s+m+sha256
$A/baum Alles
!$A/baum/tmp
EOF
step "1. Version"; aide --version 2>&1 | head -1
step "2. Konfiguration prüfen und Datenbank anlegen (aide --init)"
aide -c $A/aide.conf --config-check 2>&1 | head -3; echo "Rückgabewert --config-check: ${PIPESTATUS[0]}"
aide -c $A/aide.conf --init 2>&1 | grep -E 'Number of entries|AIDE successfully|Start timestamp' | sed -E 's/Start timestamp: .*/Start timestamp: (Zeit weggelassen)/'
mv $A/aide.db.neu $A/aide.db
step "3. Prüfung ohne Änderung (aide --check): Rückgabewert 0 = keine Abweichung"
aide -c $A/aide.conf --check >/dev/null 2>&1; echo "Rückgabewert: $?"
step "4. Änderungen vornehmen: Inhalt ändern, Datei hinzufügen, Rechte ändern"
echo "port=2222" > $A/baum/etc/dienst.conf; echo "neu" > $A/baum/etc/unerwartet.conf; chmod 777 $A/baum/bin/tool
step "5. Prüfung nach den Änderungen"
aide -c $A/aide.conf --check 2>&1 | grep -E 'Total number|Added entries|Removed entries|Changed entries|^(f|d)[ +-]|^  (Perm|SHA256|Size)' | sed "s#$A/##" | head -16; echo "Rückgabewert (Bitmaske, 0 = keine Abweichung): ${PIPESTATUS[0]}"
step "6. fail2ban-regex: Filter 'sshd' gegen eine Beispiel-Protokolldatei"
F2B=$(command -v fail2ban-regex); /usr/bin/python3.12 $F2B -V 2>&1 | head -1
/usr/bin/python3.12 $F2B $L sshd 2>&1 | grep -E '^(Lines:|Failregex|Ignoreregex)|^\|  +[0-9]+ ' | sed -E 's/\\x1b\[[0-9;]*m//g' | cut -c1-140
echo; echo "Beispielhafte Jail-Einstellung (jail.local, hier nicht aktiviert):"
cat <<'EOF'
[sshd]
enabled  = true
port     = ssh
maxretry = 3
findtime = 10m
bantime  = 1h
ignoreip = 127.0.0.1/8 10.14.0.0/24
EOF
