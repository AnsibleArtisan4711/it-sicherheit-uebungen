#!/usr/bin/env bash
# Inventarisiert lauschende Dienste (ss), schaltet nicht benötigte ab und prüft/setzt Kernel-Parameter (sysctl) im Namespace "srv".
# Benötigt: ss, sysctl, python3, nc, ip, root. Das Testlabor hat kein systemd; Dienste werden daher als Prozesse gestartet und beendet.
set -u
. "$(dirname "$0")/../lab.sh"
trap lab_down EXIT; lab_up
step "1. Ausgangszustand: drei Dienste lauschen auf allen Adressen (ss -tulpn im Namespace srv)"
( setsid ip netns exec p14-srv python3 -m http.server 8080 --bind 0.0.0.0 >/dev/null 2>&1 < /dev/null & )
( setsid ip netns exec p14-srv nc -l -k -p 2323 >/dev/null 2>&1 < /dev/null & )
( setsid ip netns exec p14-srv socat UDP-RECVFROM:5353,fork EXEC:cat >/dev/null 2>&1 < /dev/null & )
sleep 0.8
on srv ss -tulpnH | awk '{printf "%-4s %-22s %s\n",$1,$5,$7}' | sed -E 's/users:\(\("([^"]+)",pid=[0-9]+,fd=[0-9]+\)\)/prozess=\1/' | sort
step "2. Von außen erreichbar? (Namespace cl)"
for p in 8080 2323; do on cl nc -z -w1 10.14.0.1 $p >/dev/null 2>&1 && echo "tcp/$p offen" || echo "tcp/$p geschlossen"; done
step "3. Nicht benötigte Dienste beenden (Telnet-ähnlicher Port 2323, UDP-Echo 5353) und Webdienst an die Management-Adresse binden"
for pat in 'nc -l -k -p 2323' 'UDP-RECVFROM:5353' 'http.server 8080'; do pkill -f -- "$pat"; done; sleep 0.4
( setsid ip netns exec p14-srv python3 -m http.server 8080 --bind 127.0.0.1 >/dev/null 2>&1 < /dev/null & ); sleep 0.6
on srv ss -tulpnH | awk '{printf "%-4s %-22s %s\n",$1,$5,$7}' | sed -E 's/users:\(\("([^"]+)",pid=[0-9]+,fd=[0-9]+\)\)/prozess=\1/' | sort
for p in 8080 2323; do on cl nc -z -w1 10.14.0.1 $p >/dev/null 2>&1 && echo "tcp/$p offen" || echo "tcp/$p geschlossen"; done

step "4. Kernel-Parameter: Soll-Ist-Vergleich (sysctl -n, Auszug)"
cat > /tmp/p14-soll.txt <<'EOF'
kernel.randomize_va_space 2
fs.protected_hardlinks 1
fs.protected_symlinks 1
fs.suid_dumpable 0
kernel.dmesg_restrict 1
kernel.kptr_restrict 2
kernel.unprivileged_bpf_disabled 1
net.ipv4.tcp_syncookies 1
net.ipv4.conf.all.rp_filter 1
net.ipv4.conf.all.accept_redirects 0
net.ipv4.conf.all.send_redirects 0
net.ipv4.conf.all.accept_source_route 0
net.ipv4.conf.all.log_martians 1
net.ipv4.icmp_echo_ignore_broadcasts 1
net.ipv6.conf.all.accept_ra 0
EOF
printf '%-42s %-6s %-6s %s\n' Parameter Ist Soll Status
while read -r k soll; do
  ist=$(on srv sysctl -n "$k" 2>/dev/null || echo "fehlt")
  [ "$ist" = "$soll" ] && st=ok || st=ABWEICHUNG
  printf '%-42s %-6s %-6s %s\n' "$k" "$ist" "$soll" "$st"
done < /tmp/p14-soll.txt
step "5. Abweichende Netzwerk-Parameter im Namespace srv setzen (sysctl -w) und erneut prüfen"
for k in $(awk '$1 ~ /^net.ipv4/ {print $1}' /tmp/p14-soll.txt); do
  v=$(grep "^$k " /tmp/p14-soll.txt | cut -d' ' -f2); on srv sysctl -qw "$k=$v" && echo "gesetzt: $k=$v"
done
printf '%-42s %-6s %-6s %s\n' Parameter Ist Soll Status
while read -r k soll; do case $k in net.*) ist=$(on srv sysctl -n "$k" 2>/dev/null || echo "fehlt"); [ "$ist" = "$soll" ] && st=ok || st=ABWEICHUNG; printf '%-42s %-6s %-6s %s\n' "$k" "$ist" "$soll" "$st";; esac; done < /tmp/p14-soll.txt
step "6. Dauerhaft: Datei /etc/sysctl.d/99-haertung.conf (Beispiel, hier nicht angelegt): Zeilenformat und Existenz der Schlüssel prüfen"
awk '{print $1" = "$2}' /tmp/p14-soll.txt | tee /tmp/p14-99.conf | head -4; echo "…"
echo "(Absichtlich kein 'sysctl -p' im Testlabor: Es würde die Kernel-Parameter des Hosts ändern.)"
while read -r k _ _; do p=/proc/sys/$(echo "${k%% *}" | tr . /); [ -e "$p" ] || echo "Schlüssel fehlt auf diesem System: ${k%% *}"; done < /tmp/p14-99.conf
rm -f /tmp/p14-soll.txt /tmp/p14-99.conf
step "7. Pakete: Beispiel für unerwünschte Altlasten (nur Prüfung, keine Änderung)"
dpkg -l 2>/dev/null | awk '/^ii/ {print $2}' | grep -E '^(telnet|telnetd|rsh-server|rsh-client|nis|talk|ftp|tftp|xinetd|inetutils-telnetd)$' || echo "keines der geprüften Altpakete installiert"
echo "Installierte Pakete insgesamt: $(dpkg -l | grep -c '^ii')"
