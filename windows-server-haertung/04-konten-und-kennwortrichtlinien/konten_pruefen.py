#!/usr/bin/env python3
"""Prüft einen Konten-Export (CSV, erfundene Daten): Gastkonto aktiv, Kennwort läuft nie ab bei Administratoren, lange nicht benutzte aktive Konten, Remote-Rechte."""
import csv, datetime, sys
STICHTAG = datetime.date(2026, 11, 20); GRENZE = 90
if __name__ == '__main__':
    n = 0
    for r in csv.DictReader(open(sys.argv[1] if len(sys.argv) > 1 else 'konten_export.csv', encoding='utf-8', newline=''), delimiter=';'):
        m = []; admin = 'Admin' in r['gruppen']
        if r['konto'] == 'Gast' and r['aktiv'] == 'ja': m.append('Gastkonto aktiv')
        if admin and r['kennwort_laeuft_nie_ab'] == 'ja' and r['typ'] != 'dienst': m.append('Administrator mit nie ablaufendem Kennwort')
        if admin and r['typ'] == 'dienst': m.append('Dienstkonto mit Administratorrechten (gMSA und geringere Rechte prüfen)')
        tage = 0
        if r['aktiv'] == 'ja' and r['letzte_anmeldung']:
            tage = (STICHTAG - datetime.date.fromisoformat(r['letzte_anmeldung'])).days
            if tage > GRENZE: m.append('seit %d Tagen nicht angemeldet, Konto noch aktiv' % tage)
        if 'Remotedesktop' in r['gruppen'] and tage > GRENZE: m.append('Remote-Anmelderecht bei ungenutztem Konto')
        n += bool(m); print('%-14s %-9s %s' % (r['konto'], r['typ'], '; '.join(m) or 'ok'))
    print('\nAuffällige Konten: %d (Stichtag %s)' % (n, STICHTAG))
