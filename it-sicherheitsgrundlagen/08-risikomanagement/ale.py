#!/usr/bin/env python3
"""Quantitative Risikoberechnung: SLE = Assetwert * Expositionsfaktor, ALE = SLE * ARO.

Rechnet mit Ganzzahlen in Cent, damit keine Gleitkomma-Rundung auftritt.
Aufruf: python3 ale.py
Stand: Entwurf, in der Testumgebung mit Python 3 ausgefuehrt.
"""


def sle(assetwert_eur, expositionsfaktor_prozent):
    return assetwert_eur * expositionsfaktor_prozent // 100


def ale(sle_eur, aro_zehntel):
    """aro_zehntel: jaehrliche Eintrittsrate in Zehnteln (0,5 = 5)."""
    return sle_eur * aro_zehntel // 10


def main():
    asset, ef, aro = 50000, 40, 5
    s = sle(asset, ef)
    a = ale(s, aro)
    print(f"Assetwert {asset} EUR, Expositionsfaktor {ef} %, ARO 0,{aro}")
    print(f"SLE = {s} EUR")
    print(f"ALE = {a} EUR   (Kontrollwert des Lehrplans: 10000 EUR)")
    assert a == 10000
    kosten, aro_neu = 3000, 1
    a_neu = ale(s, aro_neu)
    print(f"\nMaßnahme (Beispiel) kostet {kosten} EUR pro Jahr und senkt die ARO auf 0,{aro_neu}")
    print(f"ALE danach = {a_neu} EUR; Einsparung = {a - a_neu} EUR; Nutzen minus Kosten = {a - a_neu - kosten} EUR")


if __name__ == "__main__":
    main()
