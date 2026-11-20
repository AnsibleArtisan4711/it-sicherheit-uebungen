#!/usr/bin/env bash
# lab.sh – Hilfsfunktionen und kleines Netzwerk-Labor für die Skripte der Übungsreihe P14
#
#   cl (10.14.0.2/24) --- srv (10.14.0.1/24)       zwei Netzwerk-Namespaces, verbunden durch ein veth-Paar
#
# Nutzung:  . "$(dirname "$0")/../lab.sh"; lab_up ... lab_down
# Nur im Testlabor als root ausführen. Das Skript legt Namespaces mit dem Präfix p14- an und entfernt sie
# in lab_down wieder. Skripte, die Dateien unter /etc ändern, sichern sie vorher und stellen sie nachher zurück.

P=p14
on() { local ns=$1; shift; ip netns exec "$P-$ns" "$@"; }        # on srv ss -tlnp = im Namespace des Servers ausführen
cmd() { echo "\$ $*"; "$@" 2>&1; return $?; }                      # Befehl anzeigen und ausführen
step() { echo; echo "## $*"; }                                     # Überschrift in der Ausgabe

lab_down() {
  { for n in cl srv; do ip netns pids "$P-$n" 2>/dev/null | xargs -r kill >/dev/null 2>&1; ip netns del "$P-$n" 2>/dev/null; done; } 2>/dev/null
  wait 2>/dev/null
  return 0
}

lab_up() {
  lab_down
  for n in cl srv; do ip netns add "$P-$n"; on $n ip link set lo up; done
  ip link add v-cl type veth peer name v-srv; ip link set v-cl netns $P-cl; ip link set v-srv netns $P-srv
  on cl ip addr add 10.14.0.2/24 dev v-cl;   on cl ip link set v-cl up
  on srv ip addr add 10.14.0.1/24 dev v-srv; on srv ip link set v-srv up
}
