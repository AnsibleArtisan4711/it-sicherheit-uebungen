#!/usr/bin/env python3
"""Wandelt eine Nmap-XML-Ausgabe (-oX) in zwei CSV-Tabellen um: Hosts und offene Ports (Semikolon als Trenner)."""
import sys, csv, xml.etree.ElementTree as ET

def lese(pfad):
    hosts, ports = [], []
    for h in ET.parse(pfad).getroot().iter('host'):
        st = h.find('status').get('state')
        ip = next((a.get('addr') for a in h.findall('address') if a.get('addrtype') == 'ipv4'), '')
        hn = h.find('hostnames/hostname')
        hosts.append([ip, st, hn.get('name') if hn is not None else ''])
        for p in h.findall('ports/port'):
            s = p.find('state'); sv = p.find('service')
            if s.get('state') != 'open':
                continue
            prod = ' '.join(x for x in [sv.get('product', ''), sv.get('version', '')] if x) if sv is not None else ''
            ports.append([ip, p.get('portid'), p.get('protocol'), sv.get('name', '') if sv is not None else '', prod])
    return hosts, ports

if __name__ == '__main__':
    hosts, ports = lese(sys.argv[1])
    w = csv.writer(sys.stdout, delimiter=';', lineterminator='\n')
    print('# Hosts'); w.writerow(['ip', 'zustand', 'name']); w.writerows(hosts)
    print('# Offene Ports'); w.writerow(['ip', 'port', 'protokoll', 'dienst', 'produkt_version']); w.writerows(sorted(ports, key=lambda r: (r[0], int(r[1]))))
