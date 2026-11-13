#!/usr/bin/env python3
"""CVSS-v3.1-Basiswert aus einem Vektor berechnen (Lernhilfe).

Gewichte und Formeln stammen aus dem Gedaechtnis des Verfassers (CVSS v3.1) und sind
NICHT gegen die Spezifikation von FIRST.Org gelesen. Der Selbsttest vergleicht mit
Werten, die der Verfasser aus dem Gedaechtnis als bekannt ansieht; er ist kein
Nachweis der Richtigkeit. Fuer verbindliche Werte den Rechner von FIRST.Org nutzen.
Aufruf: python3 cvss31.py            (Selbsttest und Bericht)
        python3 cvss31.py VEKTOR     (einzelner Vektor)
Stand: Entwurf, in der Testumgebung mit Python 3 ausgefuehrt.
"""
import math
import os
import sys

AV = {"N": 0.85, "A": 0.62, "L": 0.55, "P": 0.2}
AC = {"L": 0.77, "H": 0.44}
PR_U = {"N": 0.85, "L": 0.62, "H": 0.27}
PR_C = {"N": 0.85, "L": 0.68, "H": 0.5}
UI = {"N": 0.85, "R": 0.62}
CIA = {"H": 0.56, "L": 0.22, "N": 0.0}


def roundup(x):
    """Aufrunden auf eine Nachkommastelle (Verfahren ohne Gleitkomma-Fehler)."""
    i = round(x * 100000)
    if i % 10000 == 0:
        return i / 100000.0
    return (math.floor(i / 10000) + 1) / 10.0


def parse(vektor):
    teile = vektor.split("/")
    if teile[0] != "CVSS:3.1":
        raise ValueError("Vektor muss mit CVSS:3.1 beginnen")
    return dict(t.split(":") for t in teile[1:])


def basiswert(vektor):
    m = parse(vektor)
    geaendert = m["S"] == "C"
    iss = 1 - (1 - CIA[m["C"]]) * (1 - CIA[m["I"]]) * (1 - CIA[m["A"]])
    if geaendert:
        impact = 7.52 * (iss - 0.029) - 3.25 * (iss - 0.02) ** 15
    else:
        impact = 6.42 * iss
    pr = (PR_C if geaendert else PR_U)[m["PR"]]
    expl = 8.22 * AV[m["AV"]] * AC[m["AC"]] * pr * UI[m["UI"]]
    if impact <= 0:
        return 0.0
    if geaendert:
        return roundup(min(1.08 * (impact + expl), 10))
    return roundup(min(impact + expl, 10))


def stufe(wert):
    if wert == 0:
        return "None"
    if wert < 4.0:
        return "Low"
    if wert < 7.0:
        return "Medium"
    if wert < 9.0:
        return "High"
    return "Critical"


SELBSTTEST = [
    ("CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H", 9.8),
    ("CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:C/C:H/I:H/A:H", 10.0),
    ("CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H", 7.8),
    ("CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:N/I:N/A:H", 5.5),
    ("CVSS:3.1/AV:N/AC:L/PR:N/UI:R/S:C/C:L/I:L/A:N", 6.1),
    ("CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:N", 6.5),
    ("CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:N", 9.1),
]


def main():
    if len(sys.argv) > 1:
        w = basiswert(sys.argv[1])
        print(f"{w} ({stufe(w)})")
        return
    print("Selbsttest (Vergleichswerte aus dem Gedächtnis des Verfassers):")
    fehler = 0
    for v, soll in SELBSTTEST:
        ist = basiswert(v)
        ok = "ok " if ist == soll else "ABWEICHUNG"
        fehler += ist != soll
        print(f"  {ok} {ist:>4} (erwartet {soll:>4})  {v}")
    print(f"Abweichungen: {fehler}")
    bericht = os.path.join(os.path.dirname(os.path.abspath(__file__)), "schwachstellenbericht.md")
    print("\nVektoren aus schwachstellenbericht.md:")
    with open(bericht, encoding="utf-8") as f:
        for zeile in f:
            if zeile.startswith("| FIKTIV-"):
                zellen = [z.strip() for z in zeile.strip().strip("|").split("|")]
                vektor = zellen[3].strip("`")
                w = basiswert(vektor)
                print(f"  {zellen[0]}  {w:>4} {stufe(w):<8} {zellen[1]}")


if __name__ == "__main__":
    main()
