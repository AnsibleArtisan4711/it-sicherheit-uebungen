#!/usr/bin/env python3
"""Lebenszyklus eines Befunds als Zustandsautomat: erlaubte und unerlaubte Übergänge prüfen (Beispieldaten frei erfunden)."""
import sys

# Zustände laut Prozess: Erfassen -> Bewerten -> Beheben (oder Ausnahme) -> Prüfen -> Geschlossen
UEBERGAENGE = {
    'neu':        {'bewertet'},
    'bewertet':   {'zugewiesen', 'falsch-positiv', 'ausnahme'},
    'zugewiesen': {'behoben', 'ausnahme'},
    'behoben':    {'geprueft'},
    'geprueft':   {'geschlossen', 'zugewiesen'},      # Nachprüfung fehlgeschlagen -> zurück an die Bearbeitung
    'ausnahme':   {'zugewiesen', 'geschlossen'},      # Ausnahme abgelaufen -> wieder bearbeiten; oder Ziel entfällt
    'falsch-positiv': {'geschlossen'},
    'geschlossen': set(),
}

def wechsel(b, neu):
    if neu not in UEBERGAENGE[b['zustand']]:
        return 'ABGELEHNT: %s -> %s (erlaubt: %s)' % (b['zustand'], neu, ', '.join(sorted(UEBERGAENGE[b['zustand']])) or 'keiner')
    b['zustand'] = neu
    return 'ok: jetzt %s' % neu

befunde = {'B-001': {'titel': 'TLS 1.0 aktiv auf 10.15.0.11:443', 'zustand': 'neu'},
           'B-002': {'titel': 'Dateiliste auf Port 8080', 'zustand': 'neu'},
           'B-003': {'titel': 'Telnet-ähnlicher Dienst auf Port 2323', 'zustand': 'neu'}}
ablauf = [('B-001', 'bewertet'), ('B-001', 'zugewiesen'), ('B-001', 'geschlossen'),     # Schritt übersprungen: Prüfen fehlt
          ('B-001', 'behoben'), ('B-001', 'geprueft'), ('B-001', 'geschlossen'),
          ('B-002', 'bewertet'), ('B-002', 'falsch-positiv'), ('B-002', 'geschlossen'),
          ('B-003', 'behoben'),                                                          # ohne Bewertung
          ('B-003', 'bewertet'), ('B-003', 'ausnahme'), ('B-003', 'zugewiesen')]
if __name__ == '__main__':
    for bid, neu in ablauf:
        print('%s %-14s %s' % (bid, neu, wechsel(befunde[bid], neu)))
    print()
    for bid, b in befunde.items():
        print('%s | %-14s | %s' % (bid, b['zustand'], b['titel']))
