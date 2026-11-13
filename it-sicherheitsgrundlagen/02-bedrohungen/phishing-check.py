#!/usr/bin/env python3
"""Regelbasierte Vorpruefung von .eml-Dateien auf Phishing-Indikatoren.

Lernhilfe, kein Spam-Filter: Es zaehlt nur Anzeichen und ersetzt nicht das Urteil
des Menschen. Aufruf: python3 phishing-check.py   (liest mail-*.eml neben dem Skript)
Stand: Entwurf, in der Testumgebung mit Python 3 ausgefuehrt.
"""
import glob
import os
import re
from email import policy
from email.parser import BytesParser

EIGENE_DOMAIN = "med.example.com"
DRINGLICHKEIT = ["dringend", "sofort", "24 stunden", "heute noch", "gesperrt",
                 "unwiderruflich", "vertraulich", "nicht erreichbar"]


def domain_von(adresse):
    m = re.search(r"@([A-Za-z0-9.\-]+)", adresse or "")
    return m.group(1).lower() if m else ""


def aehnlich(dom):
    """Enthaelt die Domain den Namen der eigenen Domain, ist aber weder sie noch eine Subdomain?"""
    kern = re.sub(r"[^a-z0-9]", "", dom)
    if not dom or dom == EIGENE_DOMAIN or dom.endswith("." + EIGENE_DOMAIN):
        return False
    return "medexample" in kern


def links(msg):
    body = msg.get_body(preferencelist=("html", "plain"))
    text = body.get_content() if body else ""
    return re.findall(r'<a href="([^"]+)">([^<]+)</a>', text), text


def pruefe(pfad):
    with open(pfad, "rb") as f:
        msg = BytesParser(policy=policy.default).parse(f)
    befunde = []
    von = domain_von(str(msg["From"]))
    antwort = domain_von(str(msg["Reply-To"])) if msg["Reply-To"] else ""
    rueck = domain_von(str(msg["Return-Path"]))
    auth = str(msg["Authentication-Results"] or "").lower()
    if aehnlich(von):
        befunde.append(f"Absender-Domain '{von}' ähnelt '{EIGENE_DOMAIN}', ist aber eine andere")
    elif von and von != EIGENE_DOMAIN:
        befunde.append(f"Absender-Domain '{von}' ist nicht '{EIGENE_DOMAIN}'")
    if antwort and antwort != von:
        befunde.append(f"Reply-To ('{antwort}') weicht von From ('{von}') ab")
    if rueck and rueck != von:
        befunde.append(f"Return-Path ('{rueck}') weicht von From ('{von}') ab")
    for verfahren in ("spf", "dkim", "dmarc"):
        m = re.search(verfahren + r"=(\w+)", auth)
        if m and m.group(1) != "pass":
            befunde.append(f"{verfahren.upper()}: {m.group(1)}")
    ziele, text = links(msg)
    for href, anzeige in ziele:
        d_href = domain_von("@" + re.sub(r"^https?://", "", href).split("/")[0])
        d_anz = domain_von("@" + re.sub(r"^https?://", "", anzeige).split("/")[0])
        if d_href != d_anz:
            befunde.append(f"Link-Text zeigt '{d_anz}', Ziel ist '{d_href}'")
    if re.search(r"anhang", text.lower()) and not list(msg.iter_attachments()):
        befunde.append("Text verweist auf einen Anhang, es ist aber keiner vorhanden")
    wörter = [w for w in DRINGLICHKEIT if w in (str(msg["Subject"]) + " " + text).lower()]
    if wörter:
        befunde.append("Druck-/Dringlichkeitswörter: " + ", ".join(wörter))
    return str(msg["Subject"]), befunde


def main():
    ordner = os.path.dirname(os.path.abspath(__file__))
    for pfad in sorted(glob.glob(os.path.join(ordner, "mail-*.eml"))):
        betreff, befunde = pruefe(pfad)
        print(f"== {os.path.basename(pfad)}: {betreff}")
        print(f"   Anzahl Befunde: {len(befunde)}")
        for b in befunde:
            print("   -", b)
        if not befunde:
            print("   - keine Auffälligkeiten durch diese Regeln (kein Beweis für Echtheit)")


if __name__ == "__main__":
    main()
