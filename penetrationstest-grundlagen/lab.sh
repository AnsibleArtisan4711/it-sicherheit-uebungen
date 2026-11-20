#!/usr/bin/env bash
# Gemeinsame Hilfen der Übungsreihe (P64). Alles läuft nur auf 127.0.0.1; Dateien unter /tmp/p64. Alle Daten sind erfunden.
W=/tmp/p64; HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP=8080; APP2=8081; SSHP=2222; FTPP=2121
step() { echo; echo "## $*"; }
cmd() { echo "\$ $*"; "$@" 2>&1; return $?; }
warte() { for i in $(seq 1 50); do (exec 3<>/dev/tcp/127.0.0.1/$1) 2>/dev/null && return 0; sleep 0.1; done; return 1; }
lab_up() {
  lab_down >/dev/null 2>&1; mkdir -p "$W"
  nohup python3 "$HERE/app.py" $APP >/dev/null 2>&1 & echo $! >> "$W/pids"
  nohup python3 "$HERE/app.py" $APP2 lockout >/dev/null 2>&1 & echo $! >> "$W/pids"
  nohup python3 "$HERE/banner.py" $SSHP "SSH-2.0-LabSSH_0.1" >/dev/null 2>&1 & echo $! >> "$W/pids"
  nohup python3 "$HERE/banner.py" $FTPP "220 LabFTP 1.0 ready" >/dev/null 2>&1 & echo $! >> "$W/pids"
  for p in $APP $APP2 $SSHP $FTPP; do warte $p || echo "Port $p nicht bereit"; done
}
lab_down() { [ -f "$W/pids" ] && kill $(cat "$W/pids") 2>/dev/null; sleep 0.2; rm -rf "$W"; }
trap 'lab_down >/dev/null 2>&1' EXIT
nm() { nmap "$@" 2>&1 | grep -v '^Starting Nmap\|^Nmap done\|^Host is up'; }
