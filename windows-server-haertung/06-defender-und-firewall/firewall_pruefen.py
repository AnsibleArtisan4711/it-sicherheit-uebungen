#!/usr/bin/env python3
"""Prüft eine Firewall-Regelliste (CSV, erfundene Daten): eingehende Erlauben-Regeln mit Any bei Adresse, Port oder Protokoll; Regeln im Profil Any; deaktivierte Regeln (aufräumen)."""
import csv, sys
if __name__ == '__main__':
    n = 0
    for r in csv.DictReader(open(sys.argv[1] if len(sys.argv) > 1 else 'firewall_regeln.csv', encoding='utf-8', newline=''), delimiter=';'):
        m = []
        if r['aktiv'] == 'nein': m.append('deaktiviert: löschen, wenn nicht mehr gebraucht')
        elif r['richtung'] == 'Inbound' and r['aktion'] == 'Allow':
            if r['protokoll'] == 'Any' and r['lokaler_port'] == 'Any' and r['remote_adresse'] == 'Any': m.append('KRITISCH: erlaubt alles von überall')
            elif r['remote_adresse'] == 'Any' and r['lokaler_port'] in ('3389', '5985', '5986', '445', '135', '139'): m.append('Verwaltungs-/Dateidienst für alle Adressen offen: auf Verwaltungsnetz begrenzen')
            if r['profil'] == 'Any': m.append('gilt in allen Profilen (auch Öffentlich)')
        n += bool(m); print('%-20s %-8s %-6s %-6s %-6s %-14s %s' % (r['name'], r['richtung'], r['aktion'], r['protokoll'], r['lokaler_port'], r['remote_adresse'], '; '.join(m) or 'ok'))
    print('\nRegeln mit Handlungsbedarf: %d' % n)
