#!/usr/bin/env python3
"""Vergleicht einen Dienste-Export (CSV, erfundene Daten) mit einer Positivliste für die Rolle „Dateiserver“.
Ausgabe: laufende Dienste, die nicht erlaubt sind, mit Vorschlag (Starttyp deaktivieren, beenden)."""
import csv, sys
if __name__ == '__main__':
    erlaubt = {r['name']: r for r in csv.DictReader(open(sys.argv[2] if len(sys.argv) > 2 else 'rolle_dateiserver.csv', encoding='utf-8', newline=''), delimiter=';')}
    n = g = 0
    for r in csv.DictReader(open(sys.argv[1] if len(sys.argv) > 1 else 'dienste_export.csv', encoding='utf-8', newline=''), delimiter=';'):
        e = erlaubt.get(r['name'])
        if e is None: erg = 'NICHT IN DER LISTE: klären (Rolle oder Software?)'
        elif e['erlaubt'] == 'nein' and r['status'] == 'Running': erg = 'ABSCHALTEN: %s' % e['begruendung']
        elif e['erlaubt'] == 'nein': erg = 'läuft nicht; Starttyp auf „Disabled“ setzen, wenn %s' % r['startart']
        else: erg = 'ok: %s' % e['begruendung']
        g += 1; n += not erg.startswith('ok'); print('%-15s %-9s %-12s %s' % (r['name'], r['status'], r['startart'], erg))
    print('\nHandlungsbedarf: %d von %d Diensten' % (n, g))
