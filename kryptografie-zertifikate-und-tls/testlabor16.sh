#!/bin/bash
# Hilfsmittel (NICHT Teil des Lehrplans): baut linux01 und win11-01 ohne Hyper-V in Netzwerk-Namespaces nach.
# Nur als root auf einem Linux-Testrechner, nicht auf einem Produktivsystem. Benötigt: iproute2, openssl, curl, tshark.
# Verwendung:  source testlabor16.sh; lab_up   # linux01 = 192.168.10.10, win11 = 192.168.10.20 (eth0 in beiden)
#              ip netns exec linux01 <befehl>  # Befehl in "linux01"
#              lab_down
# Unterschied zu den VMs: win11 ist hier ein Linux-Namespace mit curl (OpenSSL-Backend), kein Windows (Schannel).
# Stand: Entwurf; ausgeführt auf Ubuntu 24.04, nicht auf Hyper-V.
lab_up(){
  ip netns add linux01; ip netns add win11
  ip link add vl01 type veth peer name vw11
  ip link set vl01 netns linux01; ip link set vw11 netns win11
  ip -n linux01 link set vl01 name eth0; ip -n win11 link set vw11 name eth0
  ip -n linux01 addr add 192.168.10.10/24 dev eth0; ip -n win11 addr add 192.168.10.20/24 dev eth0
  for n in linux01 win11; do ip -n $n link set eth0 up; ip -n $n link set lo up; done
}
lab_down(){ for n in linux01 win11; do ip netns del $n 2>/dev/null; done; }
