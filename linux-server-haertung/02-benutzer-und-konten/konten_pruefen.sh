#!/usr/bin/env bash
# Legt Testkonten an und prüft Konten: UID 0, leere Passwörter, Shells, Passwort-Ablauf, Sperren.
# Benötigt: useradd, usermod, chage, chpasswd, userdel, awk, root.
# Nur im Testlabor ausführen: Das Skript legt die Konten t14anna, t14bernd und t14root2 im echten /etc an und löscht sie am Ende wieder.
set -u
cleanup() { for u in t14anna t14bernd t14root2 t14dienst; do userdel -f -r "$u" >/dev/null 2>&1; done; rm -f /tmp/p14-shadow.bak; }
trap cleanup EXIT; cleanup
echo "## Testkonten anlegen"
useradd -m -s /bin/bash -c "Anna Beispiel" t14anna
useradd -m -s /bin/bash -c "Bernd Beispiel" t14bernd
useradd -r -s /usr/sbin/nologin -d /var/lib/t14dienst t14dienst
useradd -o -u 0 -g 0 -M -s /bin/bash -c "Zweites root (absichtlich falsch)" t14root2 2>&1 | grep -v '^$'
echo 't14anna:Beispiel-Passwort-123!' | chpasswd
usermod -p '' t14bernd                                   # absichtlich leeres Passwortfeld
echo; echo "## 1. Konten mit UID 0 (erwartet: nur root)"
awk -F: '$3==0 {print $1}' /etc/passwd
echo; echo "## 2. Konten mit leerem Passwortfeld (erwartet: keines)"
awk -F: '$2=="" {print $1}' /etc/shadow
echo; echo "## 3. Konten mit Anmelde-Shell, UID 0 oder ab 1000 (Passwortstatus aus /etc/shadow)"
awk -F: 'NR==FNR{s[$1]=$2; next} ($7!~/nologin|false/) && ($3==0 || ($3>=1000 && $3<65534)) {printf "%-9s uid=%-6s shell=%-10s pw=%s\n",$1,$3,$7,(s[$1]==""?"LEER":(s[$1]~/^[!*]/?"gesperrt":"gesetzt"))}' /etc/shadow FS=: /etc/passwd | grep -E '^(root|t14)'
echo; echo "## 4. Passwort-Ablauf für t14anna setzen und anzeigen (chage)"
chage -M 90 -m 1 -W 14 t14anna; chage -l t14anna | sed 's/^/   /'
echo; echo "## 5. Konto sperren (usermod -L) und Shell sperren (usermod -s)"
usermod -L -s /usr/sbin/nologin t14bernd
awk -F: '$1=="t14bernd"{print "t14bernd: Passwortfeld beginnt mit \"" substr($2,1,1) "\" (Sperre)"}' /etc/shadow; grep '^t14bernd:' /etc/passwd | cut -d: -f1,7
passwd -S t14anna; passwd -S t14bernd
echo; echo "## 6. Vorgaben in /etc/login.defs (Auszug der echten Datei)"
grep -E '^(PASS_MAX_DAYS|PASS_MIN_DAYS|PASS_WARN_AGE|UMASK|ENCRYPT_METHOD|SHA_CRYPT_(MIN|MAX)_ROUNDS|YESCRYPT_COST_FACTOR)' /etc/login.defs
echo; echo "## 7. Hash-Verfahren von t14anna (Kennung im Passwortfeld)"
awk -F: '$1=="t14anna"{split($2,a,"$"); print "Kennung $" a[2] "$  (6 = SHA-512, y = yescrypt)"}' /etc/shadow
echo; echo "## 8. Aufräumen: Konten entfernen und prüfen"
cleanup; getent passwd t14anna t14bernd t14root2 t14dienst || echo "alle Testkonten entfernt"
