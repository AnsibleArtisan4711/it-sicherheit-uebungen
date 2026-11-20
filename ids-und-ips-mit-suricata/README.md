# IDS und IPS mit Suricata (P62)

Übungsreihe zu IDS und IPS mit Suricata: Grundlagen, Regeln schreiben, Mitschnitte offline analysieren, Protokollfelder (HTTP, DNS, TLS), Tuning und Fehlalarme, IPS-Betrieb im Überblick, Regelverwaltung sowie Betrieb, Auswertung und Abschlussprojekt. 8 Module, 100 Unterrichtseinheiten zu 45 Minuten, davon 1 Modul mit Priorität 2 (Vertiefung). Praxisübungen mit echten Läufen im Offline-Modus; nur eigene Systeme untersuchen. Die Aufgabentexte und Kontrollfragen stammen aus dem Lehrplan P62 (Reihe „Lehrplan-Prompts“, Datei `P62-ids-und-ips-mit-suricata.md`) und sind unverändert; Hinweise, Musterlösungen und Ergänzungen sind Teil der Ausarbeitung und gekennzeichnet.

> **Prüfstand, ehrlich:** **Im Cloud-Container ausgeführt, nicht in Hyper-V.** Die Skripte liefen mit Suricata 7.0.3 im Offline-Modus (Ubuntu 24.04) auf Mitschnitten von der Loopback-Schnittstelle; die Ausgaben stehen in den Ordnern `beispiele/`. Alle Daten sind erfunden. **Inline-Betrieb (IPS), `suricata-update` und Regelquellen wurden nicht ausgeführt**: Diese Teile sind Textdateien aus Fachwissen und nicht bestätigt. Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Umgebung

Eine Linux-VM unter **Hyper-V** (Lehrplan): `ids01` (`10.62.0.2`, Debian oder Ubuntu) am privaten Switch `Lab-IDS` (`10.62.0.0/24`). Das Labor wurde **nicht** aufgebaut. Die Skripte erzeugen stattdessen Verkehr an der Loopback-Schnittstelle des Testrechners und brauchen `root` (Port 53 und `tcpdump`).

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [IDS und IPS: Suricata im Überblick](01-suricata-im-ueberblick/) | 9 h | Skript im Container ausgeführt. |
| 02 | [Regeln schreiben](02-regeln-schreiben/) | 10,5 h | Skript im Container ausgeführt. |
| 03 | [Mitschnitte offline analysieren](03-mitschnitte-analysieren/) | 10,5 h | Skript im Container ausgeführt. |
| 04 | [Protokolle und Felder: HTTP, DNS, TLS](04-protokolle-und-felder/) | 10,5 h | Skript im Container ausgeführt. |
| 05 | [Tuning und Fehlalarme](05-tuning-und-fehlalarme/) | 9 h | Skript im Container ausgeführt. |
| 06 | [IPS-Betrieb im Überblick](06-ips-betrieb/) (Priorität 2) | 9 h | Skript im Container ausgeführt; Inline-Betrieb nicht ausgeführt. |
| 07 | [Regelverwaltung](07-regelverwaltung/) | 7,5 h | Skript im Container ausgeführt; suricata-update nicht ausgeführt. |
| 08 | [Betrieb, Auswertung und Abschlussprojekt](08-betrieb-auswertung-und-abschlussprojekt/) | 9 h | Skript im Container ausgeführt. |

Summe 75 Stunden.

## Aufbau eines Moduls

Ordner `NN-kurzname/` mit `README.md`, der Übung `NN.1-….md` (Lernziele, Voraussetzungen, Grundbegriffe, Aufgaben, Hinweise, Kontrollfragen, einklappbare Musterlösung, Erweiterungen, Quellen), den Skripten und Beispieldaten des Moduls und einem Ordner `beispiele/` mit den echten Ausgaben der Läufe. Die Skripte der Module liegen im jeweiligen Modulordner und binden `../lab.sh` ein.

## Hinweise

- Die Skripte starten kurzzeitig einen Webserver (Port 8080), einen DNS-Server (Port 53) und `openssl s_server` (Port 8443) auf `127.0.0.1` und schneiden den Verkehr mit `tcpdump` mit. **Nicht auf einem Rechner ausführen, auf dem diese Ports belegt sind.**
- Untersuchen Sie ausschließlich Systeme, die Ihnen gehören oder für die Sie eine schriftliche Erlaubnis haben. Alle Namen, Adressen (`10.62.0.0/24`) und Daten sind erfunden.
- Die Textdateien `ips_nfqueue.txt` und `regelquellen.txt` wurden nicht ausgeführt und nicht gegen die Dokumentation geprüft.

## Lizenz

- Skripte: MIT, siehe [`LICENSE`](LICENSE)
- Texte: CC BY 4.0, siehe [`LICENSE-DOCS.md`](LICENSE-DOCS.md)

*Lizenz: Text CC BY 4.0, Skripte MIT, siehe `LICENSE-DOCS.md` und `LICENSE` im Kursordner. Alle Personen, Firmen, Zahlen und Termine sind frei erfunden. Windows und Windows Server sind Marken der Microsoft Corporation; dieses Dokument steht in keiner Verbindung zu Microsoft.*
