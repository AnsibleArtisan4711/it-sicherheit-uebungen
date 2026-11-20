#!/usr/bin/env python3
"""Priorisiert Befunde nach Risiko im Kontext: CVSS-Basiswert, Kritikalität und Exposition des Systems, bekannte Ausnutzung (KEV), Ausnutzungswahrscheinlichkeit (EPSS).
Die Gewichte sind Annahmen für die Übung, keine Norm."""
import csv, glob, importlib.util, os, sys

def lade_cvss():
    p = glob.glob(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '05*', 'cvss_rechner.py'))[0]
    spec = importlib.util.spec_from_file_location('cvss_rechner', p); m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m); return m

EXPO = {'intern': 0.8, 'dmz': 1.0, 'internet': 1.2}
FRIST = [(9.0, 'P1', 7), (6.5, 'P2', 30), (4.0, 'P3', 90), (0.0, 'P4', 180)]   # (Mindestrisiko, Klasse, Tage bis zur Behebung)

def risiko(cvss, kritik, expo, epss, kev):
    r = cvss * (0.6 + 0.1 * kritik) * EXPO[expo]
    if kev == 'ja': r += 2.0
    if epss >= 0.5: r += 1.0
    return round(min(r, 10.0), 1)

def klasse(r):
    for grenze, k, tage in FRIST:
        if r >= grenze: return k, tage

def lies(p):
    with open(p, encoding='utf-8', newline='') as f: return list(csv.DictReader(f, delimiter=';'))

if __name__ == '__main__':
    d = os.path.dirname(os.path.abspath(__file__)); cv = lade_cvss()
    fbef = sys.argv[1] if len(sys.argv) > 1 else os.path.join(d, 'befunde.csv')
    fass = sys.argv[2] if len(sys.argv) > 2 else os.path.join(d, 'assets.csv')
    assets = {a['host']: a for a in lies(fass)}
    erg = []
    for b in lies(fbef):
        a = assets[b['host']]; w = cv.basiswert(b['cvss_vektor'])[0]
        r = risiko(w, int(a['kritikalitaet']), a['exposition'], float(b['epss']), b['kev'])
        k, t = klasse(r); erg.append((r, b['id'], b['host'], b['titel'], w, a['kritikalitaet'], a['exposition'], b['epss'], b['kev'], k, t))
    print('%-5s %-5s %-12s %-36s %-5s %-4s %-8s %-5s %-4s %-5s %s' % ('Rang', 'ID', 'Host', 'Titel', 'CVSS', 'Krit', 'Expos.', 'EPSS', 'KEV', 'Prio', 'Frist (Tage)'))
    for n, e in enumerate(sorted(erg, reverse=True), 1):
        print('%-5d %-5s %-12s %-36s %-5.1f %-4s %-8s %-5s %-4s %-5s %d  (Risiko %.1f)' % (n, e[1], e[2], e[3][:36], e[4], e[5], e[6], e[7], e[8], e[9], e[10], e[0]))
    print('\nVergleich: reine Sortierung nach CVSS-Basiswert')
    for n, e in enumerate(sorted(erg, key=lambda x: (-x[4], x[1])), 1): print('%-5d %-5s %-36s CVSS %.1f' % (n, e[1], e[3][:36], e[4]))
