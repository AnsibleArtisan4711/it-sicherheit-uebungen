# Anmerkungen zum Lehrplan P64

Beim Ausarbeiten und Testen aufgefallene Punkte. Der Lehrplan selbst wurde zusammen mit der Übungsreihe erstellt und danach **nicht** verändert.

| Nr. | Modul | Befund | Vorschlag |
|---|---|---|---|
| 1 | alle | **Ausführung:** Alle Skripte liefen im Cloud-Container (Ubuntu 24.04, kein systemd) ausschließlich gegen das eigene Loopback-Labor (`127.0.0.1`). Verhalten in echten Netzen, mit Firewalls und mit anderen nmap-Versionen wurde nicht getestet. Alle Daten sind erfunden. | Übungen auf `pt01` und `ziel01` nachvollziehen; Ausgaben vergleichen. |
| 2 | alle | **Nicht ausgeführt:** Metasploit, Burp Suite, Schwachstellenscanner, Scans über ein Netz. Die Beispielanwendung ist absichtlich unsicher und gehört nur in das isolierte Labor. | Nur im isolierten Labor einsetzen. |
| 3 | alle | **Quellen:** Die Dokumentation von nmap, Rechtsvorschriften und Vorgehensmodelle wurden nicht gelesen; rechtliche Aussagen sind keine Rechtsberatung. | Quellen lesen und eintragen; rechtlich prüfen lassen. |
| 4 | 04 | **Dienstnamen:** nmap nennt die Dienste nach der Portnummer (`ccproxy-ftp`, `EtherNetIP-1`); das ist ohne Versionserkennung zu erwarten. Im Testbereich 2000 bis 9000 waren weitere, nicht zum Labor gehörende Ports offen; das Skript wertet nur die Labor-Ports aus. | Auf dem Prüfsystem mit leerem Port-Bereich vergleichen. |
| 5 | 05 | **TRACE:** Die Beispielanwendung nennt TRACE in `Allow`, setzt die Methode aber nicht um; die Ausgabe von `http-security-headers` blieb leer, die Deutung ist nicht gegen die Dokumentation geprüft. | Mit der Dokumentation der nmap-Version belegen. |
| 6 | 07 | **Priorität:** Modul 7 ist Priorität 2; kein anderes Modul setzt es voraus. | Bei Zeitmangel entfallen lassen. |
| 7 | 08 | **Bewertungsmodell:** Die Skala 1 bis 3 und die Schwellen (ab 6 hoch, ab 3 mittel) sind eigene Annahmen und nicht aus einem anerkannten Verfahren abgeleitet. | Mit einem anerkannten Verfahren vergleichen. |
