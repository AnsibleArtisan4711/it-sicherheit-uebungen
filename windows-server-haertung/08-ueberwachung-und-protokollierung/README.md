# 08 Audit

Übung **08.1** (Priorität 1). Geschätzte Zeit: 5 bis 7 Stunden (Schätzung; Lehrplan: 9 UE zu 45 Minuten = 6,75 Stunden).

> Skript im Container ausgeführt; `auditpol` nicht ausgeführt.

| Datei | Zweck |
|---|---|
| `08.1-ueberwachung-und-protokollierung.md` | Die Übung mit Aufgaben, Kontrollfragen und Musterlösung |
| `audit_ist.csv` | Beispieldaten (CSV, Semikolon als Trenner, frei erfunden) |
| `audit_soll.csv` | Beispieldaten (CSV, Semikolon als Trenner, frei erfunden) |
| `audit_vergleich.py` | Vergleicht die wirksame Überwachungsrichtlinie (Format wie `auditpol /get /category:* /r`, CSV, erfundene Beispieldaten) mit einer Soll-Tabelle. |
| `lauf.sh` | Vergleicht die Beispiel-Überwachungsrichtlinie mit dem Soll (Python 3). |
| `beispiele/lauf.ausgabe.txt` | Echte Ausgabe des Laufs von `lauf` |
