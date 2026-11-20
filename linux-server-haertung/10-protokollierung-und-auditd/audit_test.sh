#!/usr/bin/env bash
# Startet auditd, lädt Regeln (audit.rules), löst Ereignisse aus und wertet sie mit ausearch und aureport aus.
# Benötigt: auditd (auditctl, ausearch, aureport), root, Kernel mit Audit-Unterstützung. Regeln und Testdateien werden am Ende entfernt.
set -u
cd "$(dirname "$0")" || exit 1; . ../lab.sh
cleanup() { auditctl -D >/dev/null 2>&1; pkill -x auditd 2>/dev/null; sleep 0.5; rm -f /etc/p14-watch.conf /etc/sudoers.d/p14-audit; rm -rf /var/log/audit/audit.log*; }
trap cleanup EXIT; pkill -x auditd 2>/dev/null; sleep 0.5; rm -f /var/log/audit/audit.log*
mkdir -p /var/log/audit; auditctl -D >/dev/null 2>&1; auditd; sleep 2
step "1. Zustand von auditd (auditctl -s, Auszug)"
auditctl -s | grep -E '^(enabled|failure|backlog_limit|lost) '
step "2. Regeln laden (auditctl -R audit.rules) und anzeigen (auditctl -l)"
auditctl -R audit.rules >/dev/null 2>&1; echo "Rückgabewert auditctl -R: $?"
echo '$ auditctl -l'; auditctl -l
step "3. Ereignisse auslösen"
touch /etc/p14-watch.conf; echo "wert=1" >> /etc/p14-watch.conf; chmod 600 /etc/p14-watch.conf
echo "# Test" > /etc/sudoers.d/p14-audit; chmod 440 /etc/sudoers.d/p14-audit
useradd -m t14aud; chage -l t14aud >/dev/null; userdel -r t14aud >/dev/null 2>&1
mkdir -p /tmp/p14-m; mount -t tmpfs tmpfs /tmp/p14-m; umount /tmp/p14-m; rmdir /tmp/p14-m
sleep 1.5
step "4. Ereignisse nach Schlüsselwort (aureport -k --summary)"
aureport -k --summary 2>&1 | sed '/^$/d'
step "5. Dateiereignisse lesen: aureport -f -i (Datum und Uhrzeit weggelassen)"
aureport -f -i 2>/dev/null | grep -E 'p14-watch|sudoers.d/p14' | awk '{printf "%-28s %-9s %-5s %-18s\n", $4, $5, $6, $7}' | sort | uniq -c
echo; echo '$ ausearch -k p14_konfig -x /usr/bin/chmod -i  (Auszug: SYSCALL-Zeile)'
ausearch -k p14_konfig -x /usr/bin/chmod -i 2>/dev/null | grep -E '^type=SYSCALL' | sed -E 's/msg=audit\([^)]*\) ://; s/ (a[0-3]|items|ppid|pid|auid|gid|euid|suid|fsuid|egid|sgid|fsgid|tty|ses|arch)=[^ ]*//g' | cut -c1-150
step "6. Wer hat chage ausgeführt? (ausearch -k p14_privileg -x /usr/bin/chage)"
ausearch -k p14_privileg -x /usr/bin/chage -i 2>/dev/null | grep -E '^type=SYSCALL' | sed -E 's/.*(syscall=[a-z]+).*(uid=[a-z0-9]+).*(comm=[a-z0-9]+).*(exe=[^ ]+).*/\1 \2 \3 \4/' | sort | uniq -c
echo "(auid=unset im Testlabor: kein echter Anmeldevorgang; in der VM steht hier das Konto, mit dem man sich angemeldet hat)"
step "7. Umgang mit dem Datenvolumen: Größe des Protokolls und Rotation"
ls -l /var/log/audit/audit.log | awk '{print "audit.log: " $5 " Bytes"}'
grep -E '^(max_log_file|num_logs|max_log_file_action|space_left_action) ' /etc/audit/auditd.conf
