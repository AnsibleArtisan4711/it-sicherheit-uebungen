#!/usr/bin/env python3
"""Vergleicht die wirksame Überwachungsrichtlinie (Format wie `auditpol /get /category:* /r`, CSV, erfundene Beispieldaten) mit einer Soll-Tabelle.
Spaltennamen und Aufbau der Ausgabe von auditpol sind aus Fachwissen übernommen und nicht gegen die Dokumentation geprüft."""
import csv, sys
def deckt(ist, soll):
    s = {'Success and Failure': {'S', 'F'}, 'Success': {'S'}, 'Failure': {'F'}, 'No Auditing': set()}
    return s[soll] <= s[ist]
if __name__ == '__main__':
    ist = {r['Subcategory']: r['Inclusion Setting'] for r in csv.DictReader(open(sys.argv[1] if len(sys.argv) > 1 else 'audit_ist.csv', encoding='utf-8', newline=''))}
    n = 0
    for r in csv.DictReader(open(sys.argv[2] if len(sys.argv) > 2 else 'audit_soll.csv', encoding='utf-8', newline=''), delimiter=';'):
        i = ist.get(r['subcategory'], 'No Auditing'); ok = deckt(i, r['soll']); n += not ok
        print('%-26s Soll: %-20s Ist: %-20s %s' % (r['subcategory'], r['soll'], i, 'ok' if ok else 'LÜCKE (Ereignisse %s fehlen)' % r['ereignisse']))
    print('\nLücken: %d' % n)
