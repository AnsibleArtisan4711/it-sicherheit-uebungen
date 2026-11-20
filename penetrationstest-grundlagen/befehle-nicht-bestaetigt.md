# Befehle und Aussagen, die nicht bestätigt sind

Prüfliste für den ersten Durchlauf in den Hyper-V-VMs: Befund und Datum eintragen, danach den Hinweis in der Übung entfernen. Legende: **Q** = gegen Quelle gelesen; **L** = im Labor (Container) ausgeführt; **–** = weder noch.

| Modul | Befehl oder Aussage | Status | Nächster Schritt |
|---|---|---|---|
| alle | Aufbau des Hyper-V-Labors (privater Switch `Lab-Pentest`, `pt01`, `ziel01`) | – | laut Lehrplan aufbauen und prüfen |
| 01 | Auftragsdatei und Scope-Prüfer in Python (`ipaddress`) | L | auf `pt01` wiederholen |
| 02 | Notizfunktion mit `sha256` und JSON-Zeilen; `curl -sI` | L | auf `pt01` wiederholen |
| 03 | `ss -ltn`, Banner über Sockets, `curl -sI`, `robots.txt` | L | auf `pt01` und `ziel01` wiederholen |
| 04 | `nmap -sT`, `-p`, `--open`, `--reason`, `-oG`, `--script banner` | L (nmap 7.94SVN, nur Loopback); `-sV` dauerte 87 s und ist nicht in der Übung | mit Verkehr zwischen zwei VMs wiederholen; `-sS` mit Rechten nicht ausgeführt |
| 05 | nmap-Skripte `http-title`, `http-server-header`, `http-methods`, `http-robots.txt`, `http-security-headers`; Checkliste mit `curl` | L; `http-security-headers` gab keine Ausgabe | Skriptausgabe mit der Dokumentation belegen |
| 06 | `curl` mit Marker, Pfadliste, Statuscodes | L (eigene Beispielanwendung) | auf `ziel01` wiederholen |
| 07 | `curl -d` gegen `/login` mit und ohne Sperre | L (eigene Beispielanwendung) | auf `ziel01` wiederholen |
| 08 | Befundliste, Risikoformel, Berichtsgerüst mit `awk` | L | auf `pt01` wiederholen |
