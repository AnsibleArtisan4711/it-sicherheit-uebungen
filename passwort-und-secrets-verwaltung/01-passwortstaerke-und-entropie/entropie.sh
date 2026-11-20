#!/usr/bin/env bash
# Modul 1: Passwortstärke rechnen (Zeichensätze, Entropie, Rate-Zeit-Modell). Reine Rechnung mit erfundenen Annahmen.
. "$(dirname "$0")/../lab.sh"
step "1. Entropie nach Zeichensatz und Länge (zufällig gewählt)"
python3 - <<'PY'
import math
sets = {"nur Ziffern": 10, "Kleinbuchstaben": 26, "Klein+Groß": 52, "Klein+Groß+Ziffern": 62, "alle druckbaren (94)": 94}
print("%-22s %6s %6s %6s %6s" % ("Zeichensatz", "L=8", "L=12", "L=16", "L=20"))
for n, k in sets.items():
    print("%-22s %6.1f %6.1f %6.1f %6.1f" % ((n,) + tuple(L * math.log2(k) for L in (8, 12, 16, 20))))
print("\nPassphrase aus Wörtern (Wortliste mit 7776 Wörtern, zufällig gewählt):")
for w in (4, 5, 6): print(f"  {w} Wörter: {w*math.log2(7776):.1f} Bit")
PY
step "2. Rate-Zeit-Modell (Annahme: 1e10 Versuche je Sekunde gegen einen schnellen Hash, 1e3 gegen langsamen Hash)"
python3 - <<'PY'
import math
def dauer(bits, rate):
    s = 2 ** (bits - 1) / rate           # im Mittel die Hälfte des Raums
    for n, d in (("Jahre", 31557600), ("Tage", 86400), ("Stunden", 3600), ("Minuten", 60)):
        if s >= d: return "%.3g %s" % (s / d, n)
    return "%.3g Sekunden" % s
print("%-8s %-22s %-22s" % ("Bit", "schneller Hash (1e10/s)", "langsamer Hash (1e3/s)"))
for b in (28, 40, 52, 64, 77, 100): print("%-8d %-22s %-22s" % (b, dauer(b, 1e10), dauer(b, 1e3)))
PY
step "3. Aus Mustern wird weniger Entropie: Wörterbuchwort + 2 Ziffern"
python3 - <<'PY'
import math
print("Wörterbuch mit 100000 Wörtern, ein Wort + 2 Ziffern: %.1f Bit" % math.log2(100000 * 100))
print("Zum Vergleich 8 zufällige Zeichen aus 62:           %.1f Bit" % (8 * math.log2(62)))
PY
