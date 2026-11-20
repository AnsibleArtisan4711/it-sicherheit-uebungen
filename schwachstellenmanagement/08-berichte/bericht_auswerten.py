#!/usr/bin/env python3
"""Wertet einen Scanbericht (CSV, frei erfundene Beispieldaten) aus: Zahl je Schweregrad, je Host, unsichere Funde, Vorschläge für die Verifikation."""
import csv, sys, collections

ORDNUNG = ['kritisch', 'hoch', 'mittel', 'niedrig']

def lade(pfad):
    with open(pfad, encoding='utf-8', newline='') as f:
        return list(csv.DictReader(f, delimiter=';'))

if __name__ == '__main__':
    z = lade(sys.argv[1] if len(sys.argv) > 1 else 'beispiel_bericht.csv')
    print('Funde insgesamt: %d' % len(z))
    print('\nJe Schweregrad:')
    c = collections.Counter(r['schweregrad'] for r in z)
    for s in ORDNUNG: print('  %-9s %d' % (s, c.get(s, 0)))
    print('\nJe Host (Zahl, höchster CVSS-Wert):')
    h = collections.defaultdict(list)
    for r in z: h[r['host']].append(float(r['cvss']))
    for k in sorted(h): print('  %-12s %d Funde, höchster Wert %.1f' % (k, len(h[k]), max(h[k])))
    print('\nUnsichere Funde (Erkennungsqualität QoD unter 70 oder nur Versionsabgleich) – vor der Behebung verifizieren:')
    for r in z:
        if int(r['qod']) < 70 or r['erkennung'] == 'nein':
            print('  %s %s:%s %s (QoD %s, aktive Prüfung: %s)' % (r['id'], r['host'], r['port'], r['titel'], r['qod'], r['erkennung']))
    print('\nAuffälligkeiten (Plausibilität):')
    for r in z:
        w = float(r['cvss'])
        soll = 'kritisch' if w >= 9 else 'hoch' if w >= 7 else 'mittel' if w >= 4 else 'niedrig'
        if w == 0.0: print('  %s hat CVSS 0.0, aber Schweregrad %s: Informationsfund oder Fehler in der Bewertung' % (r['id'], r['schweregrad']))
        elif soll != r['schweregrad']: print('  %s: Schweregrad %s passt nicht zum Wert %.1f (erwartet %s)' % (r['id'], r['schweregrad'], w, soll))
