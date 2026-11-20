#!/usr/bin/env python3
"""Berechnet Kennzahlen aus dem Befundverlauf (CSV, frei erfunden): mittlere Behebungsdauer (MTTR) je Priorität, Fristeinhaltung, offene und überfällige Befunde."""
import csv, datetime, collections, sys

STICHTAG = datetime.date(2026, 11, 20)

if __name__ == '__main__':
    pfad = sys.argv[1] if len(sys.argv) > 1 else 'befunde_verlauf.csv'
    zeilen = list(csv.DictReader(open(pfad, encoding='utf-8', newline=''), delimiter=';'))
    dauer = collections.defaultdict(list); in_frist = [0, 0]; offen = []; ueberfaellig = []
    for r in zeilen:
        g = datetime.date.fromisoformat(r['gefunden']); frist = int(r['frist_tage'])
        if r['behoben']:
            d = (datetime.date.fromisoformat(r['behoben']) - g).days
            dauer[r['prio']].append(d); in_frist[0] += d <= frist; in_frist[1] += 1
        else:
            alter = (STICHTAG - g).days; offen.append(r['id'])
            if alter > frist: ueberfaellig.append('%s (%s, %d Tage offen, Frist %d)' % (r['id'], r['prio'], alter, frist))
    print('Stichtag: %s, Befunde: %d' % (STICHTAG, len(zeilen)))
    print('\nMittlere Behebungsdauer (MTTR) in Tagen:')
    for p in sorted(dauer): print('  %s: %.1f Tage (%d Befunde)' % (p, sum(dauer[p]) / len(dauer[p]), len(dauer[p])))
    print('\nFristeinhaltung bei behobenen Befunden: %d von %d (%.0f %%)' % (in_frist[0], in_frist[1], 100 * in_frist[0] / in_frist[1]))
    print('Offene Befunde: %d (%s)' % (len(offen), ', '.join(offen)))
    print('Überfällige offene Befunde: %d' % len(ueberfaellig))
    for u in ueberfaellig: print('  ' + u)
