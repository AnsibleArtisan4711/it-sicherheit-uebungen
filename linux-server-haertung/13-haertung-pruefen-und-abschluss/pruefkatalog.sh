#!/usr/bin/env bash
# Prüfkatalog für den Abschluss: zehn automatische Prüfungen mit Ergebnis ok/FEHLER und Zusammenfassung (Rückgabewert = Zahl der Fehler).
# Benötigt: sshd, awk, stat, find, root. Liest nur; ändert nichts.
n=0; f=0
chk() { n=$((n+1)); if eval "$2" >/dev/null 2>&1; then printf '%2d ok      %s\n' $n "$1"; else f=$((f+1)); printf '%2d FEHLER  %s\n' $n "$1"; fi; }
chk "SSH: Root-Anmeldung verboten"            "[ \"\$(sshd -T 2>/dev/null | awk '/^permitrootlogin /{print \$2}')\" = no ]"
chk "SSH: Passwortanmeldung aus"              "[ \"\$(sshd -T 2>/dev/null | awk '/^passwordauthentication /{print \$2}')\" = no ]"
chk "SSH: höchstens 4 Versuche (MaxAuthTries)" "[ \"\$(sshd -T 2>/dev/null | awk '/^maxauthtries /{print \$2}')\" -le 4 ]"
chk "Nur root hat UID 0"                      "[ \"\$(awk -F: '\$3==0' /etc/passwd | wc -l)\" = 1 ]"
chk "Kein Konto mit leerem Passwort"          "[ -z \"\$(awk -F: '\$2==\"\"' /etc/shadow)\" ]"
chk "/etc/shadow nicht weltlesbar"            "[ \"\$(stat -c %A /etc/shadow | cut -c8-10)\" = --- ]"
chk "sudoers-Dateien syntaktisch in Ordnung"  "visudo -c"
chk "Maximales Passwortalter höchstens 90 Tage" "[ \"\$(awk '/^PASS_MAX_DAYS/{print \$2}' /etc/login.defs)\" -le 90 ]"
chk "Standard-umask mindestens 027"           "[ \"\$(awk '/^UMASK/{print \$2}' /etc/login.defs)\" = 027 ]"
chk "Anmeldebanner gesetzt (/etc/issue.net)"  "grep -qi 'autorisierte' /etc/issue.net"
echo; echo "Ergebnis: $((n-f)) von $n Prüfungen bestanden, $f Fehler"
exit $f
