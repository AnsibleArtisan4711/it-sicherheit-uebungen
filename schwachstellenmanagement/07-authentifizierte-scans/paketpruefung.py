#!/usr/bin/env python3
"""Simuliert eine angemeldete (authentifizierte) Prüfung: vergleicht installierte Paketversionen mit einer Hinweisliste (CSV, frei erfunden)."""
import csv, subprocess, sys

def installiert():
    out = subprocess.run(['dpkg-query', '-W', '-f', '${Package} ${Version}\n'], capture_output=True, text=True).stdout
    return dict(z.split(' ', 1) for z in out.splitlines() if ' ' in z)

def kleiner(a, b):
    """True, wenn Debian-Version a älter ist als b (dpkg --compare-versions)."""
    return subprocess.run(['dpkg', '--compare-versions', a, 'lt', b]).returncode == 0

if __name__ == '__main__':
    pfad = sys.argv[1] if len(sys.argv) > 1 else 'beispiel_hinweise.csv'
    inst = installiert()
    print('Installierte Pakete im System: %d' % len(inst))
    print('%-14s %-26s %-9s %-11s %s' % ('Hinweis', 'Paket', 'Schwere', 'Ergebnis', 'installierte Version / behoben in'))
    anz = {'verwundbar': 0, 'behoben': 0, 'nicht installiert': 0}
    with open(pfad, encoding='utf-8', newline='') as f:
        for r in csv.DictReader(f, delimiter=';'):
            v = inst.get(r['paket'])
            if v is None: erg = 'nicht installiert'; vers = '-'
            elif kleiner(v, r['behoben_in']): erg = 'verwundbar'; vers = '%s < %s' % (v, r['behoben_in'])
            else: erg = 'behoben'; vers = '%s >= %s' % (v, r['behoben_in'])
            anz[erg] += 1
            print('%-14s %-26s %-9s %-11s %s' % (r['hinweis_id'], r['paket'], r['schweregrad'], erg, vers))
    print('\nZusammenfassung: %d verwundbar, %d behoben, %d nicht installiert' % (anz['verwundbar'], anz['behoben'], anz['nicht installiert']))
