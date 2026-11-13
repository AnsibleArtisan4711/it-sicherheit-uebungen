#!/usr/bin/env python3
"""Zaehlt Anmeldeereignisse in einem sshd-Log (Lernhilfe).

Erkennt: 'Failed password for [invalid user] NAME from IP', 'Invalid user NAME from IP',
'Accepted METHODE for NAME from IP'. Meldet IP-Adressen mit mindestens SCHWELLE
Fehlversuchen und Anmeldungen mit Passwort (nach der Haertung ein Alarmzeichen).
Aufruf: python3 logzaehler.py [Logdatei]    (Standard: beispiel-sshd.log neben dem Skript)
Stand: Entwurf, in der Testumgebung mit Python 3 ausgefuehrt.
"""
import os
import re
import sys
from collections import Counter

SCHWELLE = 5
RE_FEHL = re.compile(r"Failed password for (?:invalid user )?(\S+) from (\S+)")
RE_UNBEK = re.compile(r"Invalid user (\S+) from (\S+)")
RE_OK = re.compile(r"Accepted (\S+) for (\S+) from (\S+)")


def auswerten(zeilen):
    fehl_ip, fehl_user = Counter(), Counter()
    unbekannt, ok = set(), []
    for z in zeilen:
        zeit = z[:15]
        m = RE_FEHL.search(z)
        if m:
            fehl_user[m.group(1)] += 1
            fehl_ip[m.group(2)] += 1
        m = RE_UNBEK.search(z)
        if m:
            unbekannt.add(m.group(1))
        m = RE_OK.search(z)
        if m:
            ok.append((zeit, m.group(1), m.group(2), m.group(3)))
    return fehl_ip, fehl_user, unbekannt, ok


def main():
    pfad = sys.argv[1] if len(sys.argv) > 1 else os.path.join(
        os.path.dirname(os.path.abspath(__file__)), "beispiel-sshd.log")
    with open(pfad, encoding="utf-8") as f:
        fehl_ip, fehl_user, unbekannt, ok = auswerten(f)
    print("Fehlversuche je Quelladresse:")
    for ip, n in fehl_ip.most_common():
        print(f"  {ip:<15} {n:>3}" + ("   <-- ab Schwelle, prüfen" if n >= SCHWELLE else ""))
    print("Fehlversuche je Benutzername:", dict(fehl_user.most_common()))
    print("Nicht existierende Benutzernamen:", ", ".join(sorted(unbekannt)) or "keine")
    print("Erfolgreiche Anmeldungen:")
    for zeit, methode, user, ip in ok:
        hinweis = "   <-- Passwort-Anmeldung" if methode == "password" else ""
        print(f"  {zeit}  {user:<5} von {ip}  ({methode}){hinweis}")


if __name__ == "__main__":
    main()
