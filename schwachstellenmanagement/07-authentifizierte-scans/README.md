# 07 Authent.

Übung **07.1** (Priorität 1). Geschätzte Zeit: 5 bis 7 Stunden (Schätzung; Lehrplan: 9 UE zu 45 Minuten = 6,75 Stunden).

> Linux-Skript im Container ausgeführt; Windows nicht ausgeführt.

| Datei | Zweck |
|---|---|
| `07.1-authentifizierte-scans.md` | Die Übung mit Aufgaben, Kontrollfragen und Musterlösung |
| `beispiel_hinweise.csv` | Beispieldaten (CSV, Semikolon als Trenner, frei erfunden) |
| `paketpruefung.py` | Simuliert eine angemeldete (authentifizierte) Prüfung: vergleicht installierte Paketversionen mit einer Hinweisliste (CSV, frei erfunden). |
| `paketpruefung.sh` | Läuft die Paketprüfung (paketpruefung.py) und zeigt zusätzlich die ausstehenden Updates des Systems (apt-get -s upgrade, nur Zahl und Beispiele). |
| `beispiele/paketpruefung.ausgabe.txt` | Echte Ausgabe des Laufs von `paketpruefung` |
