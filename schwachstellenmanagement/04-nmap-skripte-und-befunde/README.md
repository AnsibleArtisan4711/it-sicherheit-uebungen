# 04 NSE

Übung **04.1** (Priorität 1). Geschätzte Zeit: 5 bis 7 Stunden (Schätzung; Lehrplan: 9 UE zu 45 Minuten = 6,75 Stunden).

> Skript im Container ausgeführt.

| Datei | Zweck |
|---|---|
| `04.1-nmap-skripte-und-befunde.md` | Die Übung mit Aufgaben, Kontrollfragen und Musterlösung |
| `nmap_befunde.py` | Wertet eine Nmap-XML-Ausgabe (mit Skripten) nach einfachen Regeln aus und schreibt Befunde als CSV (Semikolon). Kein Ersatz für einen Schwachstellenscanner. |
| `nmap_skripte.sh` | Nmap-Skripte (NSE) gegen das Laborziel: TLS-Chiffren, SSH-Anmeldearten, HTTP-Titel und -Header, Banner; danach Befunde nach Regeln (nmap_befunde.py). |
| `beispiele/nmap_skripte.ausgabe.txt` | Echte Ausgabe des Laufs von `nmap_skripte` |
