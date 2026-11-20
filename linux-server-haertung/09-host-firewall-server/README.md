# 09 Host-Firewall

Übung **09.1** (Priorität 1). Geschätzte Zeit: 4 bis 6 Stunden (Schätzung; Lehrplan: 7 UE zu 45 Minuten = 5,25 Stunden).

> Skript im Container ausgeführt.

| Datei | Zweck |
|---|---|
| `09.1-host-firewall-server.md` | Die Übung mit Aufgaben, Kontrollfragen und Musterlösung |
| `firewall_test.sh` | Lädt server_firewall.nft im Namespace "srv" und prüft aus dem Namespace "cl": erlaubte und gesperrte Zugriffe, Zähler, Quelladresse. |
| `server_firewall.nft` | Host-Firewall für den Server: alles verbieten, was nicht erlaubt ist (inet = IPv4 und IPv6). |
| `beispiele/firewall_test.ausgabe.txt` | Echte Ausgabe des Laufs von `firewall_test` |
