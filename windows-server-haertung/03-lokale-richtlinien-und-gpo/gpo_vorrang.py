#!/usr/bin/env python3
"""Modell der Verarbeitungsreihenfolge von Gruppenrichtlinien (lokal, Standort, Domäne, OU: LSDOU) mit Erzwingen (Enforced) und Vererbung blockieren.
Vereinfacht: Eine Einstellung = ein Name mit Wert; später verarbeitete GPO gewinnt; erzwungene GPOs gewinnen gegen spätere und gegen „Vererbung blockieren“.
Nicht dargestellt: Sicherheitsfilter, WMI-Filter, Loopback, Schleifenverarbeitung."""
EBENEN = ['lokal', 'standort', 'domaene', 'ou-server', 'ou-server-web']

def ergebnis(gpos, blockiert_ab=None):
    """gpos: Liste (ebene, name, enforced, {einstellung: wert}); blockiert_ab: Ebene, ab der Vererbung blockiert wird."""
    wirksam, quelle = {}, {}
    for pass_enf in (False, True):               # erst normale, dann erzwungene (diese gewinnen)
        for ebene in EBENEN:
            for e, name, enf, s in gpos:
                if e != ebene or enf != pass_enf: continue
                if blockiert_ab and not enf and EBENEN.index(e) < EBENEN.index(blockiert_ab) and e != 'lokal': continue
                for k, v in s.items(): wirksam[k] = v; quelle[k] = '%s (%s)' % (name, e)
    return wirksam, quelle

def zeige(titel, gpos, blockiert_ab=None):
    w, q = ergebnis(gpos, blockiert_ab); print('--- ' + titel)
    for k in sorted(w): print('  %-26s = %-6s  aus %s' % (k, w[k], q[k]))

GPOS = [('lokal', 'Lokale Richtlinie', False, {'MinPasswortLaenge': 8, 'SMBSignierung': 0}),
        ('domaene', 'Domain-Baseline', False, {'MinPasswortLaenge': 14, 'SMBSignierung': 1, 'Gastkonto': 0}),
        ('ou-server', 'Server-Baseline', False, {'RDP-NLA': 1, 'SMBSignierung': 1}),
        ('ou-server-web', 'Webserver-Ausnahme', False, {'MinPasswortLaenge': 10})]
if __name__ == '__main__':
    zeige('1. Normaler Ablauf (lokal, Domäne, OU)', GPOS)
    zeige('2. Domain-Baseline erzwungen: die Webserver-Ausnahme (Länge 10) greift nicht mehr', [(e, n, n == 'Domain-Baseline', s) for e, n, _, s in GPOS])
    zeige('3. Vererbung auf der OU „ou-server“ blockiert (Domain-Baseline nicht erzwungen): Domänenwerte fehlen', GPOS, 'ou-server')
