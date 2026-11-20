#!/usr/bin/env python3
"""Prüft eine Anmeldeliste (CSV, erfundene Daten) gegen die Regel des Tier-Modells: Ein Konto darf sich nur an Rechnern seiner eigenen Stufe anmelden;
Anmeldungen eines höheren Kontos auf einem niedrigeren Rechner legen Zugangsdaten dort ab (Gefahr: Diebstahl); niedrigere Konten auf höheren Rechnern verletzen die Abgrenzung."""
import csv, sys
TYP = {'2': 'interaktiv', '3': 'Netzwerk', '5': 'Dienst', '10': 'RDP'}
if __name__ == '__main__':
    probleme = 0
    for r in csv.DictReader(open(sys.argv[1] if len(sys.argv) > 1 else 'anmeldungen.csv', encoding='utf-8', newline=''), delimiter=';'):
        k, h = int(r['konto_tier']), int(r['rechner_tier'])
        if k == h: erg = 'ok'
        elif k < h:
            erg = 'VERLETZUNG: Konto der Stufe %d meldet sich an Stufe %d an (%s): Zugangsdaten bleiben auf dem niedrigeren Rechner' % (k, h, TYP.get(r['anmeldetyp'], r['anmeldetyp']))
        else:
            erg = 'VERLETZUNG: Konto der Stufe %d greift auf Stufe %d zu (%s)' % (k, h, TYP.get(r['anmeldetyp'], r['anmeldetyp']))
        probleme += erg != 'ok'
        print('%s  %-13s T%d -> %-11s T%d  %s' % (r['zeit'], r['konto'], k, r['rechner'], h, erg))
    print('\nVerletzungen: %d' % probleme)
