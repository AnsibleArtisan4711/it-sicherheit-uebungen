#!/usr/bin/env bash
# Modul 3: Passwort-Richtlinie prüfen (Länge, Sperrliste, Muster) und Passphrasen erzeugen.
. "$(dirname "$0")/../lab.sh"
lab_up
cat > "$W/sperrliste.txt" <<'L'
passwort
sommer2026
willkommen1
firma123
qwertz
L
step "1. Prüfer (Regeln: mindestens 12 Zeichen, nicht in der Sperrliste, keine Wiederholung, nicht der Benutzername)"
cat > "$W/pruefer.py" <<'PY'
import re, sys
sperr = {z.strip().lower() for z in open(sys.argv[1])}
def pruefe(pw, user):
    f = []
    if len(pw) < 12: f.append("zu kurz (<12)")
    low = pw.lower()
    if any(s in low for s in sperr): f.append("enthält Wort der Sperrliste")
    if re.search(r"(.)\1{3,}", pw): f.append("vier gleiche Zeichen hintereinander")
    if user.lower() in low: f.append("enthält den Benutzernamen")
    return f
for pw, user in (("Sommer2026!", "anna"), ("anna-ist-hier-1", "anna"), ("aaaaBBBB1234", "ben"), ("kuh-lampe-wolke-tisch", "cara"), ("Willkommen1xyz", "dora"), ("kurz", "emil")):
    r = pruefe(pw, user); print("%-24s %s" % (pw, "OK" if not r else "; ".join(r)))
PY
python3 "$W/pruefer.py" "$W/sperrliste.txt"
step "2. Passphrase aus zufällig gewählten Wörtern (Wortliste mit 10 Wörtern nur zur Demonstration)"
python3 - <<'PY'
import secrets, math
w = "kuh lampe wolke tisch brot fenster apfel stein bach mond".split()
p = "-".join(secrets.choice(w) for _ in range(4))
print("Aufbau: vier Wörter, getrennt durch Bindestriche, z. B. Form", "-".join(["wort"] * 4))
print("Entropie bei 10 Wörtern und 4 Ziehungen: %.1f Bit (zu wenig; echte Liste hat tausende Wörter)" % (4 * math.log2(10)))
print("Entropie bei 7776 Wörtern und 4 Ziehungen: %.1f Bit" % (4 * math.log2(7776)))
print("Erzeugtes Beispiel hat", len(p.split("-")), "Wörter")
PY
step "3. secrets (kryptografisch sicher) gegen random (nicht für Geheimnisse): Merkmale"
python3 - <<'PY'
import random, secrets
random.seed(1); a = [random.randint(0, 9) for _ in range(6)]
random.seed(1); b = [random.randint(0, 9) for _ in range(6)]
print("random mit gleichem Startwert, zweimal gleich:", a == b, "(vorhersagbar)")
x = [secrets.randbelow(10) for _ in range(6)]; y = [secrets.randbelow(10) for _ in range(6)]
print("secrets zweimal gleich:", x == y, "(sehr unwahrscheinlich; Quelle: Betriebssystem)")
PY
lab_down
