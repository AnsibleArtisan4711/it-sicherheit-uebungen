#!/usr/bin/env bash
# Wendet eine Auswahl der Härtungsmaßnahmen aus den Modulen 1 bis 12 als Konfigurationsdateien an (Teilmenge, ohne Paketinstallation und ohne sysctl).
# Parameter: "anwenden" oder "zurueck". Sichert vorher die geänderten Dateien nach /tmp/p14-sicherung und stellt sie mit "zurueck" wieder her.
# Nur im Testlabor ausführen. In einer VM vorher einen Prüfpunkt anlegen und eine zweite SSH-Sitzung offen halten.
set -u
B=/tmp/p14-sicherung
FILES="/etc/login.defs /etc/issue /etc/issue.net /etc/ssh/sshd_config"
NEW="/etc/ssh/sshd_config.d/99-haertung.conf /etc/modprobe.d/p14-haertung.conf /etc/security/limits.d/p14-core.conf /etc/security/pwquality.conf.d/p14.conf"
case "${1:-}" in
anwenden)
  rm -rf $B; mkdir -p $B
  for f in $FILES; do [ -f $f ] && cp -p $f $B/$(echo $f | tr / _); done
  mkdir -p /etc/ssh/sshd_config.d /etc/security/limits.d /etc/security/pwquality.conf.d /etc/modprobe.d
  cat > /etc/ssh/sshd_config.d/99-haertung.conf <<'EOF'
PermitRootLogin no
PasswordAuthentication no
KbdInteractiveAuthentication no
X11Forwarding no
AllowTcpForwarding no
AllowAgentForwarding no
MaxAuthTries 3
MaxSessions 2
LoginGraceTime 30
ClientAliveInterval 300
ClientAliveCountMax 2
LogLevel VERBOSE
TCPKeepAlive no
Compression no
PermitEmptyPasswords no
EOF
  sed -i -E 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS\t90/; s/^PASS_MIN_DAYS.*/PASS_MIN_DAYS\t1/; s/^UMASK.*/UMASK\t\t027/' /etc/login.defs
  grep -q '^SHA_CRYPT_MIN_ROUNDS' /etc/login.defs || printf 'SHA_CRYPT_MIN_ROUNDS 10000\nSHA_CRYPT_MAX_ROUNDS 20000\n' >> /etc/login.defs
  printf 'Nur fuer autorisierte Benutzer. Zugriffe werden protokolliert.\n' | tee /etc/issue /etc/issue.net >/dev/null
  printf 'install cramfs /bin/false\ninstall freevxfs /bin/false\ninstall hfs /bin/false\ninstall hfsplus /bin/false\ninstall squashfs /bin/false\ninstall udf /bin/false\ninstall usb-storage /bin/false\ninstall firewire-core /bin/false\n' > /etc/modprobe.d/p14-haertung.conf
  printf '* hard core 0\n' > /etc/security/limits.d/p14-core.conf
  printf 'minlen = 12\nminclass = 3\nmaxrepeat = 2\ndictcheck = 1\nusercheck = 1\nretry = 3\n' > /etc/security/pwquality.conf.d/p14.conf
  chmod 600 /etc/ssh/sshd_config; echo "angewendet; Sicherung in $B"
  ;;
zurueck)
  for f in $FILES; do [ -f $B/$(echo $f | tr / _) ] && cp -p $B/$(echo $f | tr / _) $f; done
  rm -f $NEW; chmod 644 /etc/ssh/sshd_config; echo "zurückgesetzt"
  ;;
*) echo "Aufruf: $0 anwenden|zurueck"; exit 1;;
esac
