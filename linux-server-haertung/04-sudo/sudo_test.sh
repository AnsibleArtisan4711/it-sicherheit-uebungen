#!/usr/bin/env bash
# Prüft sudo-Regeln: Syntaxprüfung mit visudo, Rechte pro Benutzer (sudo -l), erlaubte und verweigerte Befehle, Protokolldatei.
# Benötigt: sudo, visudo, runuser, root. Legt die Konten t14ops und t14gast sowie /etc/sudoers.d/t14-test an und entfernt alles am Ende.
set -u
cleanup() { rm -f /etc/sudoers.d/t14-test /etc/sudoers.d/t14-kaputt /tmp/p14-sudo.log; userdel -r t14ops >/dev/null 2>&1; userdel -r t14gast >/dev/null 2>&1; }
trap cleanup EXIT; cleanup
useradd -m -s /bin/bash t14ops; useradd -m -s /bin/bash t14gast
echo "## Version"; sudo -V | head -1
echo; echo "## 1. Regeldatei nach Least Privilege (nur zwei Befehle, mit Protokoll)"
cat > /etc/sudoers.d/t14-test <<'EOF'
# Beispiel: Benutzer t14ops darf genau zwei Befehle als root ausführen
Cmnd_Alias T14_LESEN = /usr/bin/id, /usr/bin/tail /var/log/syslog
Defaults:t14ops logfile=/tmp/p14-sudo.log, use_pty, !visiblepw, timestamp_timeout=5
t14ops ALL=(root) NOPASSWD: T14_LESEN
EOF
chmod 0440 /etc/sudoers.d/t14-test
echo '$ visudo -cf /etc/sudoers.d/t14-test'; visudo -cf /etc/sudoers.d/t14-test
echo; echo "## 2. Absichtlich kaputte Datei: visudo meldet den Fehler, bevor sudo kaputtgeht"
printf 't14gast ALL=(root) NOPASSWD /usr/bin/id\n' > /etc/sudoers.d/t14-kaputt; chmod 0440 /etc/sudoers.d/t14-kaputt
echo '$ visudo -cf /etc/sudoers.d/t14-kaputt'; visudo -cf /etc/sudoers.d/t14-kaputt; echo "Rückgabewert: $?"
rm -f /etc/sudoers.d/t14-kaputt
echo; echo "## 3. Effektive Rechte anzeigen"
echo '$ sudo -l -U t14ops'; sudo -l -U t14ops | sed -n '/Matching/,$p'
echo; echo '$ sudo -l -U t14gast'; sudo -l -U t14gast | tail -1
echo; echo "## 4. Erlaubter und verweigerter Aufruf (als t14ops, ohne Passwortabfrage: sudo -n)"
echo '$ sudo -n /usr/bin/id'; runuser -u t14ops -- sudo -n /usr/bin/id 2>&1
echo '$ sudo -n /usr/bin/cat /etc/shadow'; runuser -u t14ops -- sudo -n /usr/bin/cat /etc/shadow 2>&1 | head -2
echo '$ sudo -n -u root /bin/bash   (Shell wäre zu mächtig)'; runuser -u t14ops -- sudo -n /bin/bash -c id 2>&1 | head -2
echo; echo "## 5. Als t14gast (keine Regel)"
runuser -u t14gast -- sudo -n /usr/bin/id 2>&1 | head -2
echo; echo "## 6. Protokolldatei der Regel (Zeit und Benutzer weggelassen)"
sed -E 's/^[A-Z][a-z]{2} +[0-9]+ [0-9:]+ : //' /tmp/p14-sudo.log | sed -E 's/PWD=[^ ]+ ;? ?//'
echo; echo "## 7. Gefahren: Befehle, die aus sudo eine Shell machen (Auszug, keine Ausführung)"
echo "vi, less, man, find -exec, awk, python, tar --checkpoint-action, systemctl (Pager) – nicht ohne Einschränkung freigeben (NOEXEC)"
