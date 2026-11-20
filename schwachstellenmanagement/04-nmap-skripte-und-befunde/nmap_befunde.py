#!/usr/bin/env python3
"""Wertet eine Nmap-XML-Ausgabe (mit Skripten) nach einfachen Regeln aus und schreibt Befunde als CSV (Semikolon). Kein Ersatz für einen Schwachstellenscanner."""
import sys, csv, xml.etree.ElementTree as ET

# Regel-Nr, Titel, Schwere (grobe Einstufung), CVSS-Vektor (eigene Annahme für die Übung, keine amtliche Einstufung)
REGELN = {
    'R1': ('Veraltetes TLS-Protokoll (TLS 1.0 oder 1.1) angeboten', 'mittel', 'CVSS:3.1/AV:N/AC:H/PR:N/UI:N/S:U/C:L/I:L/A:N'),
    'R2': ('TLS mit anonymem Schlüsselaustausch angeboten (kein Schutz vor Mitlesen und Fälschung)', 'hoch', 'CVSS:3.1/AV:N/AC:H/PR:N/UI:N/S:U/C:H/I:H/A:N'),
    'R3': ('SSH erlaubt Anmeldung mit Passwort', 'mittel', 'CVSS:3.1/AV:N/AC:H/PR:N/UI:N/S:U/C:H/I:H/A:N'),
    'R4': ('Webserver zeigt Dateiliste eines Verzeichnisses', 'mittel', 'CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N'),
    'R5': ('Dienst mit Klartext-Anmeldung (Telnet-ähnliche Kennung login:)', 'hoch', 'CVSS:3.1/AV:N/AC:H/PR:N/UI:N/S:U/C:H/I:H/A:H'),
    'R6': ('HTTPS ohne Strict-Transport-Security (HSTS)', 'niedrig', 'CVSS:3.1/AV:N/AC:H/PR:N/UI:R/S:U/C:L/I:L/A:N'),
}

def skripte(port):
    return {s.get('id'): s.get('output', '') for s in port.findall('script')}

def befunde(pfad):
    out = []
    for h in ET.parse(pfad).getroot().iter('host'):
        ip = next(a.get('addr') for a in h.findall('address') if a.get('addrtype') == 'ipv4')
        for p in h.findall('ports/port'):
            if p.find('state').get('state') != 'open':
                continue
            port = int(p.get('portid')); s = skripte(p)
            ssl = s.get('ssl-enum-ciphers', '')
            if 'TLSv1.0:' in ssl or 'TLSv1.1:' in ssl: out.append(('R1', ip, port))
            if 'Anonymous key exchange' in ssl: out.append(('R2', ip, port))
            if 'password' in s.get('ssh-auth-methods', ''): out.append(('R3', ip, port))
            if 'Directory listing' in s.get('http-title', '') or 'Index of' in s.get('http-title', ''): out.append(('R4', ip, port))
            if 'login:' in s.get('banner', ''): out.append(('R5', ip, port))
            if 'ssl-enum-ciphers' in s and 'strict-transport-security' not in s.get('http-headers', '').lower():
                out.append(('R6', ip, port))
    return sorted(set(out), key=lambda r: (r[1], r[2], r[0]))

if __name__ == '__main__':
    w = csv.writer(sys.stdout, delimiter=';', lineterminator='\n')
    w.writerow(['id', 'host', 'port', 'regel', 'titel', 'schwere', 'cvss_vektor'])
    for n, (r, ip, port) in enumerate(befunde(sys.argv[1]), 1):
        t, sch, vek = REGELN[r]
        w.writerow(['F-%03d' % n, ip, port, r, t, sch, vek])
