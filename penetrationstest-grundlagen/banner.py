#!/usr/bin/env python3
"""Kleiner Dienst, der beim Verbinden einen festen Begrüßungstext sendet (nur Loopback). Aufruf: banner.py PORT TEXT"""
import socket, sys, threading
p = int(sys.argv[1]); t = sys.argv[2].encode() + b'\r\n'
s = socket.socket(); s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1); s.bind(('127.0.0.1', p)); s.listen(5)
def h(c):
    try: c.sendall(t); c.settimeout(1); c.recv(100)
    except Exception: pass
    c.close()
while True:
    c, _ = s.accept(); threading.Thread(target=h, args=(c,), daemon=True).start()
