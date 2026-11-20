#!/usr/bin/env python3
"""Prüft ein Ausnahmeregister (CSV, frei erfundene Beispieldaten): abgelaufene Ausnahmen, bald ablaufende, fehlende Pflichtfelder."""
import csv, datetime, sys

STICHTAG = datetime.date(2026, 11, 20)     # fest für reproduzierbare Ausgabe
PFLICHT = ['begruendung', 'kompensation', 'verantwortlich', 'gueltig_bis', 'risiko_akzeptiert_von']
WARNTAGE = 30

if __name__ == '__main__':
    pfad = sys.argv[1] if len(sys.argv) > 1 else 'ausnahmen.csv'
    print('Stichtag: %s, Warnung ab %d Tagen vor Ablauf' % (STICHTAG, WARNTAGE))
    probleme = 0
    for r in csv.DictReader(open(pfad, encoding='utf-8', newline=''), delimiter=';'):
        meldungen = []
        fehlt = [p for p in PFLICHT if not r[p].strip()]
        if fehlt: meldungen.append('Pflichtfelder leer: ' + ', '.join(fehlt))
        if r['gueltig_bis']:
            rest = (datetime.date.fromisoformat(r['gueltig_bis']) - STICHTAG).days
            if rest < 0: meldungen.append('ABGELAUFEN seit %d Tagen: Befund wieder offen' % -rest)
            elif rest <= WARNTAGE: meldungen.append('läuft in %d Tagen ab: Verlängerung oder Behebung planen' % rest)
        print('%-5s %-38s %-12s %s' % (r['id'], r['befund'][:38], r['host'], '; '.join(meldungen) if meldungen else 'in Ordnung (noch %d Tage)' % rest))
        probleme += bool(meldungen)
    print('\nAusnahmen mit Handlungsbedarf: %d' % probleme)
