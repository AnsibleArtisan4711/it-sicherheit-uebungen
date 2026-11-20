#!/usr/bin/env bash
# Dateirechte, ACLs, Mount-Optionen (noexec/nosuid/nodev), SUID-Suche, Sticky-Bit und chattr an einem Loop-Dateisystem (ext4, 20 MB).
# Benötigt: mount (Loop), mkfs.ext4, setfacl/getfacl (Paket acl), chattr, find, root. Legt Konten t14a, t14b und die Gruppe t14team an; räumt am Ende auf.
set -u
. "$(dirname "$0")/../lab.sh"
M=/tmp/p14-mnt; IMG=/tmp/p14-fs.img
cleanup() { umount $M 2>/dev/null; rm -rf $M $IMG; userdel -r t14a >/dev/null 2>&1; userdel -r t14b >/dev/null 2>&1; groupdel t14team >/dev/null 2>&1; }
trap cleanup EXIT; cleanup
groupadd t14team; useradd -m -G t14team -s /bin/bash t14a; useradd -m -s /bin/bash t14b
truncate -s 20M $IMG; mkfs.ext4 -q -L p14daten $IMG; mkdir -p $M
mount -o loop,acl,nodev,nosuid,noexec $IMG $M; chmod 755 $M
step "1. Mount-Optionen des Test-Dateisystems (findmnt)"
findmnt -o TARGET,FSTYPE,OPTIONS $M | sed -E 's/relatime,//'
step "2. noexec: ein Skript auf diesem Dateisystem lässt sich nicht starten"
printf '#!/bin/sh\necho Skript gestartet\n' > $M/test.sh; chmod 755 $M/test.sh
echo '$ '$M'/test.sh'; $M/test.sh 2>&1
echo '$ sh '$M'/test.sh   (Interpreter umgeht noexec für Skripte, nicht für Binärdateien)'; sh $M/test.sh
cp /bin/true $M/true-kopie; echo '$ '$M'/true-kopie'; $M/true-kopie 2>&1; echo "Rückgabewert: $?"
step "3. Klassische Rechte: Gruppenverzeichnis mit setgid und Sticky-Bit"
mkdir $M/projekt; chown root:t14team $M/projekt; chmod 2770 $M/projekt
mkdir $M/tmp-ablage; chmod 1777 $M/tmp-ablage
ls -ld $M/projekt $M/tmp-ablage | awk '{print $1, $3, $4, $NF}'
runuser -u t14a -- touch $M/projekt/datei-a.txt; ls -l $M/projekt | awk 'NR>1{print $1, $3, $4, $NF}'
echo "(neue Datei erbt die Gruppe t14team wegen setgid)"
echo '$ t14b versucht, in projekt zu schreiben (kein Mitglied)'; runuser -u t14b -- touch $M/projekt/datei-b.txt 2>&1
echo '$ t14b versucht, die Datei von t14a im Sticky-Verzeichnis zu löschen'
runuser -u t14a -- touch $M/tmp-ablage/a.txt; runuser -u t14b -- rm -f $M/tmp-ablage/a.txt 2>&1
step "4. ACL: t14b darf lesen, aber nicht schreiben (setfacl), Standard-ACL für neue Dateien"
setfacl -m u:t14b:rx $M/projekt; setfacl -d -m u:t14b:r $M/projekt
getfacl -p $M/projekt 2>/dev/null | grep -v '^#' | sed '/^$/d'
runuser -u t14a -- touch $M/projekt/datei-neu.txt
echo '$ getfacl datei-neu.txt'; getfacl -p $M/projekt/datei-neu.txt 2>/dev/null | grep -v '^# \(file\|owner\|group\)' | sed '/^$/d'
echo '$ t14b liest / schreibt datei-neu.txt'; runuser -u t14b -- cat $M/projekt/datei-neu.txt && echo "lesen: erlaubt"; runuser -u t14b -- sh -c "echo x >> $M/projekt/datei-neu.txt" 2>&1
step "5. Unveränderbar machen mit chattr +i (auch root kann dann nicht ändern)"
echo wichtig > $M/konfig.txt; chattr +i $M/konfig.txt; lsattr $M/konfig.txt | awk '{print $1, $2}' | sed "s#$M/##"
echo '$ rm konfig.txt'; rm -f $M/konfig.txt 2>&1; echo '$ chattr -i; rm'; chattr -i $M/konfig.txt && rm $M/konfig.txt && echo gelöscht
step "6. umask: Standardrechte neuer Dateien"
for u in 022 027 077; do ( umask $u; touch $M/u$u.txt; mkdir $M/d$u; printf 'umask %s: Datei %s, Verzeichnis %s\n' $u "$(stat -c %a $M/u$u.txt)" "$(stat -c %a $M/d$u)" ); done
step "7. SUID/SGID-Dateien auf dem System suchen (nur Anzahl und Namen)"
find / -xdev \( -perm -4000 -o -perm -2000 \) -type f 2>/dev/null | grep -vE '^/(proc|sys|tmp)' | sed -E 's#.*/##' | sort | tr '\n' ' ' | fold -s -w 100; echo
echo "Anzahl: $(find / -xdev \( -perm -4000 -o -perm -2000 \) -type f 2>/dev/null | grep -vcE '^/(proc|sys|tmp)')"
step "8. Weltweit schreibbare Dateien und Verzeichnisse ohne Sticky-Bit (Prüfung, erwartet: keine)"
find / -xdev -type d -perm -0002 ! -perm -1000 2>/dev/null | grep -vE '^/(proc|sys|tmp)' | head -5 || true
echo "(Ende der Liste)"
