#!/usr/bin/env bash
# Modul 1: Recht, Ethik und Scope. Ein Auftrag mit Geltungsbereich wird als Datei geführt und von einem Prüfer erzwungen. Alle Angaben sind erfunden.
. "$(dirname "$0")/../lab.sh"
lab_up
step "1. Auftragsdatei mit Pflichtangaben (erfundene Angaben)"
cat > "$W/auftrag.txt" <<'AT'
auftraggeber: Beispiel GmbH (erfunden)
ansprechpartner: Frau Muster
pruefer: Team Lab
zeitraum: 2026-12-01 bis 2026-12-05
im_scope: 127.0.0.1, 10.64.0.0/24
ausserhalb: 10.64.0.99, Produktivsystem der Beispiel GmbH
erlaubt: Portscan, Schwachstellenpruefung, Webtests ohne Datenveraenderung
verboten: Denial-of-Service, Social Engineering, Zugriff auf echte Daten
notfallkontakt: +49 000 0000000 (erfunden)
AT
cat "$W/auftrag.txt"
step "2. Prüfer: sind alle Pflichtfelder vorhanden, und liegt ein Ziel im Scope?"
cat > "$W/scope.py" <<'PY'
import ipaddress, sys
PFLICHT = ['auftraggeber', 'ansprechpartner', 'pruefer', 'zeitraum', 'im_scope', 'ausserhalb', 'erlaubt', 'verboten', 'notfallkontakt']
def lies(pfad):
    d = {}
    for z in open(pfad, encoding='utf-8'):
        if ':' in z: k, v = z.split(':', 1); d[k.strip()] = v.strip()
    return d
def netze(text):
    out = []
    for t in text.split(','):
        t = t.strip()
        try: out.append(ipaddress.ip_network(t, strict=False))
        except ValueError: pass
    return out
def im_scope(auftrag, ziel):
    ip = ipaddress.ip_address(ziel)
    if any(ip == ipaddress.ip_address(a.strip()) for a in auftrag['ausserhalb'].split(',') if a.strip().replace('.', '').isdigit()): return False
    return any(ip in n for n in netze(auftrag['im_scope']))
a = lies(sys.argv[1])
fehlt = [f for f in PFLICHT if not a.get(f)]
print('Pflichtfelder fehlen:', fehlt if fehlt else 'keine')
for z in ['127.0.0.1', '10.64.0.5', '10.64.0.99', '10.65.0.1', '203.0.113.7']:
    print('%-12s %s' % (z, 'IM SCOPE' if im_scope(a, z) else 'NICHT im Scope: nicht testen'))
PY
python3 "$W/scope.py" "$W/auftrag.txt"
step "3. Unvollständiger Auftrag wird erkannt"
grep -v '^notfallkontakt\|^ausserhalb' "$W/auftrag.txt" > "$W/unvollstaendig.txt"
python3 - <<PY
import sys; sys.argv=['x','$W/unvollstaendig.txt']
exec(open('$W/scope.py').read().split('a = lies')[0])
a = lies('$W/unvollstaendig.txt'); print('Pflichtfelder fehlen:', [f for f in PFLICHT if not a.get(f)])
PY
step "4. Keine Erlaubnis, kein Test"
echo "Die Datei ist ein Lernmodell. Sie ersetzt weder eine schriftliche Beauftragung noch eine rechtliche Beratung."
