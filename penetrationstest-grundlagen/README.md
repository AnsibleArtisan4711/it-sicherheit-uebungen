# Penetrationstest-Grundlagen (P64)

Übungsreihe zu den Grundlagen von Penetrationstests im eigenen Labor: Recht, Ethik und Scope, Vorgehen und Dokumentation, Aufklärung, Portscans mit nmap, Fehlkonfigurationen, Prüfung einer Webanwendung, Anmeldeschutz sowie Bericht und Abschlussprojekt. 8 Module, 100 Unterrichtseinheiten zu 45 Minuten, davon 1 Modul mit Priorität 2 (Vertiefung). Praxisübungen mit echten Läufen gegen ein eigenes Loopback-Labor; keine Exploits, nur eigene Systeme. Die Aufgabentexte und Kontrollfragen stammen aus dem Lehrplan P64 (Reihe „Lehrplan-Prompts“, Datei `P64-penetrationstest-grundlagen.md`) und sind unverändert; Hinweise, Musterlösungen und Ergänzungen sind Teil der Ausarbeitung und gekennzeichnet.

> **Prüfstand, ehrlich:** **Im Cloud-Container ausgeführt, nicht in Hyper-V.** Die Skripte liefen mit nmap 7.94SVN, curl und Python 3 unter Ubuntu 24.04 ausschließlich gegen `127.0.0.1`; die Ausgaben stehen in den Ordnern `beispiele/`. Alle Daten sind erfunden. **Scans über ein Netz, Metasploit, Burp Suite und Schwachstellenscanner wurden nicht ausgeführt.** Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Umgebung

Zwei Linux-VMs unter **Hyper-V** (Lehrplan): `pt01` (`10.64.0.2`) und `ziel01` (`10.64.0.10`) am privaten Switch `Lab-Pentest` (`10.64.0.0/24`). Das Labor wurde **nicht** aufgebaut. Die Skripte starten die Beispielanwendung (`app.py`, `banner.py`) selbst auf `127.0.0.1`.

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [Recht, Ethik und Scope](01-recht-ethik-und-scope/) | 7,5 h | Skript im Container ausgeführt. |
| 02 | [Vorgehen und Dokumentation](02-vorgehen-und-dokumentation/) | 7,5 h | Skript im Container ausgeführt. |
| 03 | [Aufklärung eigener Systeme](03-aufklaerung-eigener-systeme/) | 9 h | Skript im Container ausgeführt. |
| 04 | [Portscans mit nmap](04-portscans-mit-nmap/) | 12 h | Skript im Container ausgeführt. |
| 05 | [Fehlkonfigurationen finden](05-fehlkonfigurationen-finden/) | 10,5 h | Skript im Container ausgeführt. |
| 06 | [Webanwendung prüfen](06-webanwendung-pruefen/) | 12 h | Skript im Container ausgeführt. |
| 07 | [Anmeldeschutz prüfen](07-anmeldeschutz-pruefen/) (Priorität 2) | 7,5 h | Skript im Container ausgeführt. |
| 08 | [Bericht und Abschlussprojekt](08-bericht-und-abschlussprojekt/) | 9 h | Skript im Container ausgeführt. |

Summe 75 Stunden.

## Aufbau eines Moduls

Ordner `NN-kurzname/` mit `README.md`, der Übung `NN.1-….md` (Lernziele, Voraussetzungen, Grundbegriffe, Aufgaben, Hinweise, Kontrollfragen, einklappbare Musterlösung, Erweiterungen, Quellen), den Skripten und Beispieldaten des Moduls und einem Ordner `beispiele/` mit den echten Ausgaben der Läufe. Die Skripte der Module liegen im jeweiligen Modulordner und binden `../lab.sh` ein; `app.py` und `banner.py` liegen im Kursordner.

## Hinweise

- **Prüfen Sie ausschließlich eigene Systeme oder Systeme mit schriftlicher Erlaubnis.** Die Beispielanwendung `app.py` ist absichtlich unsicher und darf nicht im Netz erreichbar sein; sie lauscht nur auf `127.0.0.1`.
- Die Skripte starten kurzzeitig Dienste auf den Ports 8080, 8081, 2121 und 2222 (Loopback). **Nicht ausführen, wenn diese Ports belegt sind.**
- Rechtliche Hinweise sind keine Rechtsberatung und wurden nicht rechtlich geprüft.

## Lizenz

- Skripte: MIT, siehe [`LICENSE`](LICENSE)
- Texte: CC BY 4.0, siehe [`LICENSE-DOCS.md`](LICENSE-DOCS.md)

*Lizenz: Text CC BY 4.0, Skripte MIT, siehe `LICENSE-DOCS.md` und `LICENSE` im Kursordner. Alle Personen, Firmen, Zahlen und Termine sind frei erfunden. Windows und Windows Server sind Marken der Microsoft Corporation; dieses Dokument steht in keiner Verbindung zu Microsoft.*
