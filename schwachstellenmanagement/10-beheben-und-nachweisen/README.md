# 10 Beheben

Übung **10.1** (Priorität 1). Geschätzte Zeit: 5 bis 7 Stunden (Schätzung; Lehrplan: 9 UE zu 45 Minuten = 6,75 Stunden).

> Skript im Container ausgeführt; Windows nicht ausgeführt.

| Datei | Zweck |
|---|---|
| `10.1-beheben-und-nachweisen.md` | Die Übung mit Aufgaben, Kontrollfragen und Musterlösung |
| `behebung_nachweis.sh` | Behebung nachweisen: Scan vorher, Maßnahmen (Zielsystem wird im gehärteten Zustand neu gestartet), Scan nachher, Vergleich. |
| `scan_vergleich.py` | Vergleicht zwei Befund-CSV-Dateien (Ausgabe von nmap_befunde.py): was ist behoben, was neu, was bleibt offen. Schlüssel: Host, Port, Regel. |
| `beispiele/behebung_nachweis.ausgabe.txt` | Echte Ausgabe des Laufs von `behebung_nachweis` |
