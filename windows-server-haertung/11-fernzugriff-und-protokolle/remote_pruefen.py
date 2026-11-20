#!/usr/bin/env python3
"""Prüft Einstellungen für Fernzugriff und Protokolle je Rechner (CSV, erfundene Daten): RDP ohne Netzwerkebenen-Authentifizierung, SMB1, fehlende SMB-Signierung,
niedrige NTLM-Stufe (LmCompatibilityLevel unter 5), WinRM nur über HTTP."""
import csv, sys
if __name__ == '__main__':
    n = 0
    for r in csv.DictReader(open(sys.argv[1] if len(sys.argv) > 1 else 'remote_einstellungen.csv', encoding='utf-8', newline=''), delimiter=';'):
        m = []
        if r['rdp_aktiv'] == 'ja' and r['rdp_nla'] == 'nein': m.append('RDP ohne NLA')
        if r['smb1'] == 'ja': m.append('SMB1 aktiv')
        if r['smb_signierung'] == 'nein': m.append('SMB-Signierung nicht verlangt')
        if int(r['ntlm_stufe']) < 5: m.append('NTLM-Stufe %s (Ziel 5)' % r['ntlm_stufe'])
        if r['winrm_http'] == 'ja' and r['winrm_https'] == 'nein': m.append('WinRM nur HTTP')
        n += bool(m); print('%-11s %s' % (r['rechner'], '; '.join(m) or 'ok'))
    print('\nRechner mit Abweichungen: %d von 4' % n)
