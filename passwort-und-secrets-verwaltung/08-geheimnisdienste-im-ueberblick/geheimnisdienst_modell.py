#!/usr/bin/env python3
"""Modell eines Geheimnisdienstes: Zugriffsrichtlinien, befristete Ausleihe (lease), Rotation, Audit-Protokoll. Erfundene Namen. Kein Produkt, kein Netzwerk."""
import secrets, itertools
zeit = itertools.count(0, 1)          # simulierte Minuten
richtlinien = {"web": {"db/lesen"}, "backup": {"db/lesen", "nas/lesen"}}
geheimnisse = {"db/lesen": "Wert-V1", "nas/lesen": "NAS-V1"}
leases, audit = [], []
def holen(rolle, pfad, ttl):
    t = next(zeit)
    if pfad not in richtlinien.get(rolle, ()):
        audit.append((t, rolle, pfad, "VERWEIGERT")); return None
    leases.append({"rolle": rolle, "pfad": pfad, "bis": t + ttl, "wert": geheimnisse[pfad]})
    audit.append((t, rolle, pfad, "ERLAUBT ttl=%d" % ttl)); return geheimnisse[pfad]
def rotieren(pfad):
    t = next(zeit); geheimnisse[pfad] = "Wert-V%d" % (int(geheimnisse[pfad][-1]) + 1)
    audit.append((t, "admin", pfad, "ROTIERT")); return geheimnisse[pfad]
print("1. Zugriff nach Richtlinie")
print("web   db/lesen  ->", holen("web", "db/lesen", 5))
print("web   nas/lesen ->", holen("web", "nas/lesen", 5))
print("2. Rotation: neue Ausleihe liefert den neuen Wert, alte Ausleihe hält den alten")
rotieren("db/lesen")
print("backup db/lesen ->", holen("backup", "db/lesen", 5))
print("3. Gültigkeit der Ausleihen zur Zeit t=7 (Ablauf nach ttl)")
for l in leases: print("%-6s %-10s bis t=%d, Wert %s, gültig: %s" % (l["rolle"], l["pfad"], l["bis"], l["wert"], l["bis"] > 7))
print("4. Audit-Protokoll")
for a in audit: print("t=%d %-7s %-10s %s" % a)
