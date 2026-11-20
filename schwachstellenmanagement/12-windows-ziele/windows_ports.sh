#!/usr/bin/env bash
# Windows-typische Ports (135, 139, 445, 3389, 5985) im Labor nachgestellt: Was sagt Nmap ohne und mit Diensterkennung?
# Es läuft KEIN Windows. Die Dienste sind Platzhalter (socat, python3 http.server) auf den üblichen Portnummern. Gezeigt wird nur, wie Portnamen entstehen.
# Benötigt: nmap, socat, python3, ip, root. Scannt nur das Labor 10.15.0.0/24.
set -u
cd "$(dirname "$0")" || exit 1; . ../lab.sh
trap lab_down EXIT; lab_up; mkdir -p $W/www
echo "Platzhalter" > $W/www/index.html
for p in 135 139 445; do ( setsid ip netns exec $P-lx socat TCP-LISTEN:$p,fork,reuseaddr SYSTEM:true >/dev/null 2>&1 < /dev/null & ); done
for p in 3389 5985; do ( cd $W/www && setsid ip netns exec $P-lx python3 -m http.server $p --bind 0.0.0.0 >/dev/null 2>&1 < /dev/null & ); done
sleep 1.2
N="on sc nmap -n -Pn"
step "1. Ohne Diensterkennung: Name kommt aus der Portnummer (nmap-services), nicht aus dem Dienst"
$N -p 135,139,445,3389,5985 10.15.0.11 | grep -E '^[0-9]+/'
step "2. Mit Diensterkennung (-sV): Nmap fragt den Dienst, was er ist"
$N -sV --version-light -p 135,139,445,3389,5985 10.15.0.11 | grep -E '^[0-9]+/' | sed -E 's/ +/ /g'
step "3. Was die Ports bei einem echten Windows-System bedeuten (Fachwissen, hier nicht gemessen)"
cat <<'T'
135   RPC-Endpunktzuordnung (Dienste melden hier ihre dynamischen Ports an)
139   NetBIOS-Sitzungsdienst (alt)
445   SMB direkt über TCP (Dateifreigaben; SMBv1 abschalten)
3389  Remotedesktop (RDP); nicht aus dem Internet erreichbar machen, Netzwerkebenen-Authentifizierung verlangen
5985  WinRM über HTTP (PowerShell-Remoting); 5986 ist die Variante mit TLS
T
step "4. Folgerung für die Auswertung"
echo "Ein Portname im Bericht ist eine Vermutung. Wichtig ist, was tatsächlich antwortet: Befunde mit -sV oder einem authentifizierten Scan belegen."
