#!/usr/bin/env python3
"""Prüft den Patchstand (CSV, erfundene Daten) gegen Fristen je Gruppe: dc 14, server 30, client 21 Tage (eigene Annahmen) und meldet ausstehende Neustarts."""
import csv, datetime, sys
STICHTAG = datetime.date(2026, 11, 20); FRIST = {'dc': 14, 'server': 30, 'client': 21}
if __name__ == '__main__':
    n = 0
    for r in csv.DictReader(open(sys.argv[1] if len(sys.argv) > 1 else 'patchstand.csv', encoding='utf-8', newline=''), delimiter=';'):
        alter = (STICHTAG - datetime.date.fromisoformat(r['letzter_patch'])).days; f = FRIST[r['gruppe']]; m = []
        if alter > f: m.append('ÜBERFÄLLIG um %d Tage' % (alter - f))
        if r['neustart_ausstehend'] == 'ja': m.append('Neustart steht aus (Patch noch nicht wirksam)')
        n += bool(m); print('%-12s %-7s Alter %3d Tage (Frist %2d)  %s' % (r['rechner'], r['gruppe'], alter, f, '; '.join(m) or 'ok'))
    print('\nBehandlungsbedarf: %d von 5 Rechnern' % n)
