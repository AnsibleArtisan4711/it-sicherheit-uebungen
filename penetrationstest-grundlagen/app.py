#!/usr/bin/env python3
"""Absichtlich unsichere Beispielanwendung für die Übungen (nur Loopback, erfundene Daten).
Aufruf: python3 app.py PORT [lockout]. Ohne 'lockout' gibt es keine Sperre nach Fehlversuchen."""
import sys, json, html
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer as HTTPServer
from urllib.parse import urlparse, parse_qs
PORT = int(sys.argv[1]); LOCK = len(sys.argv) > 2 and sys.argv[2] == 'lockout'
FAILS = {}
class H(BaseHTTPRequestHandler):
    server_version = 'ShopApp/1.0'; sys_version = ''; protocol_version = 'HTTP/1.1'
    def log_message(self, *a): pass
    def send(self, code, body, ctype='text/html; charset=utf-8', extra=None):
        b = body.encode(); self.send_response(code); self.send_header('Content-Type', ctype)
        self.send_header('Content-Length', str(len(b)))
        for k, v in (extra or {}).items(): self.send_header(k, v)
        self.end_headers()
        if self.command != 'HEAD': self.wfile.write(b)
    def do_GET(self):
        u = urlparse(self.path); q = parse_qs(u.query)
        if u.path == '/': self.send(200, '<h1>Beispiel-Shop</h1><a href="/suche?q=test">Suche</a>')
        elif u.path == '/robots.txt': self.send(200, 'User-agent: *\nDisallow: /admin\nDisallow: /backup/\n', 'text/plain')
        elif u.path == '/suche': self.send(200, '<p>Ergebnisse für: %s</p>' % q.get('q', [''])[0])   # absichtlich ohne Maskierung
        elif u.path == '/suche-sicher': self.send(200, '<p>Ergebnisse für: %s</p>' % html.escape(q.get('q', [''])[0]))
        elif u.path == '/backup/db.bak.txt': self.send(200, '# erfundene Sicherung\nkunde=Beispiel-Kunde\npasswort=Beispiel-Pw-0\n', 'text/plain')
        elif u.path == '/fehler': self.send(500, 'Traceback (most recent call last):\n  File "/srv/shop/app.py", line 42, in bestellung\nKeyError: \'artikel\'\nDB=sqlite:///srv/shop/shop.db\n', 'text/plain')
        elif u.path == '/admin': self.send(401, 'Anmeldung erforderlich', 'text/plain')
        else: self.send(404, 'nicht gefunden', 'text/plain')
    def do_HEAD(self): self.do_GET()
    def do_OPTIONS(self): self.send(204, '', extra={'Allow': 'GET, POST, OPTIONS, TRACE'})
    def do_POST(self):
        n = int(self.headers.get('Content-Length', 0)); d = parse_qs(self.rfile.read(n).decode())
        if urlparse(self.path).path != '/login': return self.send(404, 'nicht gefunden', 'text/plain')
        u = d.get('user', [''])[0]; p = d.get('pw', [''])[0]
        if LOCK and FAILS.get(u, 0) >= 3: return self.send(429, 'gesperrt', 'text/plain', {'Retry-After': '60'})
        if u == 'demo' and p == 'Beispiel-Pw-1':
            FAILS[u] = 0; return self.send(200, 'angemeldet', 'text/plain')
        FAILS[u] = FAILS.get(u, 0) + 1; self.send(401, 'falsche Zugangsdaten', 'text/plain')
HTTPServer(('127.0.0.1', PORT), H).serve_forever()
