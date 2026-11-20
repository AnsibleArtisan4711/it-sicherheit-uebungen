# 03 Entdeckung

Übung **03.1** (Priorität 1). Geschätzte Zeit: 5 bis 7 Stunden (Schätzung; Lehrplan: 9 UE zu 45 Minuten = 6,75 Stunden).

> Skript im Container ausgeführt.

| Datei | Zweck |
|---|---|
| `03.1-labor-und-entdeckung.md` | Die Übung mit Aufgaben, Kontrollfragen und Musterlösung |
| `discovery.sh` | Entdeckt Hosts und Dienste im Labornetz 10.15.0.0/24 mit Nmap (Ping-Scan, SYN-Scan, Dienst- und Versionserkennung) und erzeugt eine Bestandsliste (CSV). |
| `nmap_nach_csv.py` | Wandelt eine Nmap-XML-Ausgabe (-oX) in zwei CSV-Tabellen um: Hosts und offene Ports (Semikolon als Trenner). |
| `beispiele/discovery.ausgabe.txt` | Echte Ausgabe des Laufs von `discovery` |
