#!/usr/bin/env python3
"""Prüft eine Zielliste gegen eine Scan-Freigabe (Adressbereich, Zeitraum, Ausschlüsse, Privatnetz) und lehnt alles andere ab."""
import csv, ipaddress, sys, datetime

STICHTAG = datetime.date(2026, 11, 20)          # fest, damit die Ausgabe reproduzierbar ist; im Betrieb: datetime.date.today()

def lade(pfad):
    with open(pfad, encoding='utf-8', newline='') as f:
        return list(csv.DictReader(f, delimiter=';'))

def pruefe(ziel, freigaben, stichtag=STICHTAG):
    ip = ipaddress.ip_address(ziel)
    if not ip.is_private:
        return False, 'öffentliche Adresse: nie ohne ausdrückliche Erlaubnis des Eigentümers'
    for fg in freigaben:
        netz = ipaddress.ip_network(fg['ziele'])
        if ip not in netz:
            continue
        if any(ip == ipaddress.ip_address(x) for x in fg['ausschluss'].split(',') if x):
            return False, 'ausdrücklich ausgeschlossen (%s)' % fg['auftrag']
        von, bis = datetime.date.fromisoformat(fg['von']), datetime.date.fromisoformat(fg['bis'])
        if not (von <= stichtag <= bis):
            return False, 'außerhalb des Zeitraums %s bis %s (%s)' % (fg['von'], fg['bis'], fg['auftrag'])
        return True, 'freigegeben durch %s' % fg['auftrag']
    return False, 'keine Freigabe für diesen Bereich'

if __name__ == '__main__':
    fg = lade(sys.argv[1] if len(sys.argv) > 1 else 'freigabe.csv')
    ziele = sys.argv[2:] or ['10.15.0.11', '10.15.0.2', '10.15.0.1', '10.15.0.200', '192.168.178.1', '8.8.8.8', '10.0.0.5']
    print('Stichtag: %s' % STICHTAG)
    for z in ziele:
        ok, grund = pruefe(z, fg)
        print('%-15s %-9s %s' % (z, 'ERLAUBT' if ok else 'ABGELEHNT', grund))
    sys.exit(0)
