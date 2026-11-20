#!/usr/bin/env python3
"""Fasst Ergebnisse mehrerer Prüfungen zu einem Härtungsbericht zusammen: ruft die Prüfskripte der Module 1, 4, 5, 6, 8 und 11 mit ihren Beispieldaten auf
und zählt Abweichungen. Eigene Gewichtung: kritisch = Zeilen mit „KRITISCH“ oder „VERLETZUNG“; sonst normal."""
import glob, os, re, subprocess, sys
D = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
PRUEF = [('01*', 'baseline_vergleich.py', ['sicherheit.inf', 'baseline.csv'], 'Sicherheitsvorlage'), ('04*', 'konten_pruefen.py', ['konten_export.csv'], 'Konten'),
         ('05*', 'dienste_pruefen.py', ['dienste_export.csv', 'rolle_dateiserver.csv'], 'Dienste'), ('06*', 'firewall_pruefen.py', ['firewall_regeln.csv'], 'Firewall'),
         ('08*', 'audit_vergleich.py', ['audit_ist.csv', 'audit_soll.csv'], 'Überwachung'), ('11*', 'remote_pruefen.py', ['remote_einstellungen.csv'], 'Fernzugriff')]
if __name__ == '__main__':
    print('%-20s %-10s %s' % ('Bereich', 'Befunde', 'Beispiele'))
    gesamt = 0
    for ordner, skript, args, name in PRUEF:
        pfad = glob.glob(os.path.join(D, ordner))[0]
        out = subprocess.run([sys.executable, skript] + args, cwd=pfad, capture_output=True, text=True).stdout.splitlines()
        bad = [z for z in out if re.search(r'ABWEICHUNG|FEHLT|LÜCKE|ABSCHALTEN|NICHT IN DER LISTE|KRITISCH|Verwaltungs-|deaktiviert|aktiv;|nie ablaufend|Dienstkonto|nicht angemeldet|RDP ohne|SMB1|Signierung nicht|NTLM-Stufe|WinRM nur', z)]
        gesamt += len(bad); print('%-20s %-10d %s' % (name, len(bad), (bad[0].split('  ')[0].strip()[:40] if bad else '-')))
    print('\nBefunde gesamt: %d. Jeder Befund braucht Maßnahme, Verantwortlichen und Frist oder eine begründete Ausnahme.' % gesamt)
