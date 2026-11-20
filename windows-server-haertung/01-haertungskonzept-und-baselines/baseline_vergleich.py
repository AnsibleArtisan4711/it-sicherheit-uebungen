#!/usr/bin/env python3
"""Vergleicht eine exportierte Sicherheitsvorlage (INF-Format, erfundene Beispieldaten) mit einer eigenen Baseline-Tabelle (CSV).
Das INF-Format ist hier vereinfacht nachgebaut (Abschnitte, Schlüssel = Wert; Registry-Werte als Typ,Wert). Kein Ersatz für Policy Analyzer."""
import csv, sys

def lies_inf(pfad):
    daten, abschnitt = {}, None
    for z in open(pfad, encoding='utf-8'):
        z = z.strip()
        if not z or z.startswith(';'): continue
        if z.startswith('['): abschnitt = z.strip('[]'); continue
        if '=' in z:
            k, v = z.split('=', 1); daten[(abschnitt, k.strip())] = v.strip()
    return daten

def wert(roh):
    if ',' in roh: roh = roh.split(',', 1)[1]      # Registry-Werte: Typ,Wert
    roh = roh.strip().strip('"')
    return int(roh) if roh.lstrip('-').isdigit() else roh

OPS = {'=': lambda a, b: a == b, '>=': lambda a, b: a >= b, '<=': lambda a, b: a <= b}

if __name__ == '__main__':
    inf = lies_inf(sys.argv[1] if len(sys.argv) > 1 else 'sicherheit.inf')
    ok = abw = fehlt = 0
    print('%-70s %-4s %-6s %-6s %s' % ('Einstellung', 'Op', 'Soll', 'Ist', 'Ergebnis'))
    for r in csv.DictReader(open(sys.argv[2] if len(sys.argv) > 2 else 'baseline.csv', encoding='utf-8', newline=''), delimiter=';'):
        key = (r['bereich'], r['einstellung']); soll = wert(r['soll'])
        name = r['einstellung'].split('\\')[-1]
        if key not in inf: erg, ist = 'FEHLT', '-'; fehlt += 1
        else:
            ist = wert(inf[key]); good = OPS[r['vergleich']](ist, soll)
            erg = 'ok' if good else 'ABWEICHUNG'; ok += good; abw += not good
        print('%-70s %-4s %-6s %-6s %s' % (name, r['vergleich'], soll, ist, erg))
    print('\nok: %d, Abweichungen: %d, nicht in der Vorlage: %d' % (ok, abw, fehlt))
