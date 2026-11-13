#!/bin/bash
# Hilfsmittel (NICHT Teil des Lehrplans): baut das Drei-VM-Labor ohne Hyper-V in Netzwerk-Namespaces nach.
# So wurden die Linux-Befehle dieser Reihe getestet. Nur als root, nur auf einem Linux-Testrechner
# (nicht auf einem Produktivsystem). Benötigt: iproute2, iputils-ping.
#
# Verwendung:   source testlabor-namespaces.sh; lab_up       # Namespaces srv, lin, cli über eine Bridge im Namespace hub
#               ip netns exec lin ip -br a                   # Befehl in "VM-LINUX" (192.168.50.20)
#               ip netns exec cli ping -c1 192.168.50.20     # von "VM-WIN-CLIENT" (192.168.50.30)
#               lab_down                                     # alles entfernen
# Zuordnung: srv = VM-WIN-SRV (192.168.50.10), lin = VM-LINUX (.20), cli = VM-WIN-CLIENT (.30).
# Unterschiede zu den VMs: kein Windows (der Server wurde in Modul 12 mit nftables nachgebildet), kein systemd,
# kein Apache (stattdessen python3 -m http.server), kein Wireshark (stattdessen tcpdump).
# Stand: Entwurf; ausgeführt auf Ubuntu 24.04, nicht auf Hyper-V.
lab_up(){
  set -e
  ip netns add hub; ip netns add srv; ip netns add lin; ip netns add cli
  ip -n hub link add br0 type bridge; ip -n hub link set br0 up
  for p in "srv 10" "lin 20" "cli 30"; do set -- $p; n=$1; a=$2
    ip link add t$n type veth peer name h$n
    ip link set t$n netns $n; ip link set h$n netns hub
    ip -n $n link set t$n name eth0
    ip -n $n addr add 192.168.50.$a/24 dev eth0; ip -n $n link set eth0 up; ip -n $n link set lo up
    ip -n hub link set h$n master br0; ip -n hub link set h$n up
  done
  ip netns exec cli ping -c1 -W2 192.168.50.20 >/dev/null
  set +e
}
lab_down(){ for n in hub srv lin cli; do ip netns del $n 2>/dev/null; done; }
