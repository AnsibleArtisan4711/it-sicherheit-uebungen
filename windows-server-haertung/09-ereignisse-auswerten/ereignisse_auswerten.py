#!/usr/bin/env python3
"""Wertet Sicherheitsereignisse (CSV, erfundene Daten) mit einfachen Regeln aus: viele Fehlanmeldungen gefolgt von Erfolg derselben Quelle,
neues Konto + Aufnahme in Administratoren, gelöschtes Überwachungsprotokoll. Ereignis-Kennungen 4624, 4625, 4720, 4688 stehen in der Microsoft-Dokumentation;
4732 und 1102 sind Fachwissen (nicht geprüft)."""
import csv, collections, sys
SCHWELLE = 5
if __name__ == '__main__':
    ev = list(csv.DictReader(open(sys.argv[1] if len(sys.argv) > 1 else 'ereignisse.csv', encoding='utf-8', newline=''), delimiter=';'))
    fehl = collections.Counter((e['konto'], e['quelle']) for e in ev if e['ereignis'] == '4625')
    erfolg = {(e['konto'], e['quelle']) for e in ev if e['ereignis'] == '4624'}
    print('Regel 1: Fehlanmeldungen (Schwelle %d) und späterer Erfolg' % SCHWELLE)
    for (k, q), c in fehl.items():
        if c >= SCHWELLE: print('  %s von %s: %d Fehlversuche%s' % (k, q, c, ', danach ERFOLGREICH angemeldet (Verdacht auf Kennwortraten)' if (k, q) in erfolg else ''))
    print('Regel 2: neues Konto und Aufnahme in eine Administratorgruppe')
    neu = {e['konto'] for e in ev if e['ereignis'] == '4720'}
    for e in ev:
        if e['ereignis'] == '4732' and e['konto'] in neu and 'Administratoren' in e['details']: print('  %s: %s -> Verdacht auf Hintertür' % (e['zeit'], e['details']))
    print('Regel 3: Überwachungsprotokoll gelöscht')
    for e in ev:
        if e['ereignis'] == '1102': print('  %s auf %s durch %s' % (e['zeit'], e['quelle'], e['konto']))
