#!/usr/bin/env bash
# Prüft den Zustand von AppArmor und SELinux und die Syntax eines selbst geschriebenen AppArmor-Profils (ohne Kernel-Unterstützung).
# Benötigt: apparmor (apparmor_parser, aa-status), selinux-utils (getenforce), policycoreutils (sestatus). Durchsetzung wird NICHT getestet.
set -u
. "$(dirname "$0")/../lab.sh"
W=/tmp/p14-aa; rm -rf $W; mkdir -p $W; trap 'rm -rf $W' EXIT
step "1. Zustand der Sicherheitsmodule auf diesem System"
cmd aa-status; echo "Rückgabewert: $?"
cmd getenforce
cmd sestatus | head -3
echo; echo "Aktive Linux-Sicherheitsmodule laut Kernel:"; cat /sys/kernel/security/lsm 2>/dev/null || echo "(Datei nicht lesbar: securityfs nicht eingehängt)"
step "2. Ein Profil für ein Beispielprogramm (Datei $W/usr.local.bin.t14app)"
cat > $W/usr.local.bin.t14app <<'EOF'
#include <tunables/global>

/usr/local/bin/t14app flags=(complain) {
  #include <abstractions/base>

  /usr/local/bin/t14app mr,
  /etc/t14app/** r,
  /var/log/t14app.log w,
  deny /etc/shadow r,
  network inet stream,
}
EOF
cat $W/usr.local.bin.t14app
step "3. Syntaxprüfung ohne Laden in den Kernel (apparmor_parser -Q -K)"
apparmor_parser -Q -K $W/usr.local.bin.t14app 2>&1 | grep -v 'Cache read/write disabled'; echo "Rückgabewert: ${PIPESTATUS[0]}"
step "4. Absichtlich fehlerhaftes Profil (Zugriffsbuchstabe z ist ungültig)"
sed 's#/etc/t14app/\*\* r,#/etc/t14app/** rz,#' $W/usr.local.bin.t14app > $W/fehler
apparmor_parser -Q -K $W/fehler 2>&1 | grep -v 'Cache read/write disabled' | sed "s#$W/##g"; echo "Rückgabewert: ${PIPESTATUS[0]}"
step "5. Betriebsarten im Profil: complain (nur protokollieren) und enforce (durchsetzen)"
grep -o 'flags=([a-z,]*)' $W/usr.local.bin.t14app | sed 's/^/Profil enthält: /'
sed 's/ flags=(complain)//' $W/usr.local.bin.t14app > $W/enforce
apparmor_parser -Q -K $W/enforce 2>&1 | grep -v 'Cache read/write disabled'; echo "enforce-Variante: Syntax in Ordnung (Rückgabewert ${PIPESTATUS[0]})"
step "6. Mitgelieferte Bausteine des Pakets (Beispiele aus /etc/apparmor.d/abstractions)"
ls /etc/apparmor.d/abstractions | grep -E '^(base|nameservice|ssl_certs|openssl)$' | sed 's#^#abstractions/#'
