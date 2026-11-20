#!/usr/bin/env python3
"""Vergleicht zwei Befund-CSV-Dateien (Ausgabe von nmap_befunde.py): was ist behoben, was neu, was bleibt offen. Schlüssel: Host, Port, Regel."""
import csv, sys

def lies(p):
    with open(p, encoding='utf-8', newline='') as f:
        return {(r['host'], r['port'], r['regel']): r for r in csv.DictReader(f, delimiter=';')}

if __name__ == '__main__':
    vorher, nachher = lies(sys.argv[1]), lies(sys.argv[2])
    gruppen = [('BEHOBEN (nur im ersten Scan)', sorted(set(vorher) - set(nachher)), vorher),
               ('NEU (nur im zweiten Scan)', sorted(set(nachher) - set(vorher)), nachher),
               ('UNVERÄNDERT OFFEN', sorted(set(vorher) & set(nachher)), nachher)]
    for name, keys, quelle in gruppen:
        print('%s: %d' % (name, len(keys)))
        for k in keys: print('  %s:%s  %s  [%s]' % (k[0], k[1], quelle[k]['titel'], quelle[k]['schwere']))
    print('\nErgebnis: %d von %d Befunden behoben, %d neu, %d offen' % (len(gruppen[0][1]), len(vorher), len(gruppen[1][1]), len(gruppen[2][1])))
    sys.exit(1 if gruppen[1][1] or gruppen[2][1] else 0)
