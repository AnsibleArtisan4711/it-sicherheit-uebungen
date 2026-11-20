#!/usr/bin/env python3
"""Prüft, ob Rechner ein gültiges, nicht abgelaufenes LAPS-Kennwort in Active Directory haben (Beispiel-Export als CSV, erfundene Daten).
Das Ablaufdatum steht als FILETIME (100-ns-Schritte seit 01.01.1601 UTC) im Attribut msLAPS-PasswordExpirationTime.
Zusätzlich: Kennwortgenerator als Beispiel (Zeichenvorrat, Länge)."""
import csv, datetime, secrets, string, sys
STICHTAG = datetime.datetime(2026, 11, 20, 12, 0, tzinfo=datetime.timezone.utc)
def filetime(ft):
    return datetime.datetime(1601, 1, 1, tzinfo=datetime.timezone.utc) + datetime.timedelta(microseconds=int(ft) // 10)
def passwort(n=20):
    z = string.ascii_letters + string.digits + '!#$%&*+-=?'
    while True:
        p = ''.join(secrets.choice(z) for _ in range(n))
        if any(c.islower() for c in p) and any(c.isupper() for c in p) and any(c.isdigit() for c in p): return p
if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--passwort': print(len(passwort()), 'Zeichen erzeugt (Wert wird nicht angezeigt)'); sys.exit(0)
    n = 0
    for r in csv.DictReader(open(sys.argv[1] if len(sys.argv) > 1 else 'computer_export.csv', encoding='utf-8', newline=''), delimiter=';'):
        if not r['laps_ablauf_filetime']: erg = 'KEIN LAPS-KENNWORT im Verzeichnis'
        else:
            ab = filetime(r['laps_ablauf_filetime']); rest = (ab - STICHTAG).days
            erg = ('ABGELAUFEN seit %d Tagen (%s)' % (-rest, ab.date())) if rest < 0 else 'gültig bis %s (noch %d Tage)' % (ab.date(), rest)
        n += not erg.startswith('gültig'); print('%-12s %s' % (r['computer'], erg))
    print('\nRechner mit Handlungsbedarf: %d (Stichtag %s)' % (n, STICHTAG.date()))
