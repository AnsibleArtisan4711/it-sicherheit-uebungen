# Schwachstellenmanagement (P15)

Übungsreihe zum Schwachstellenmanagement: Prozess, rechtliche Rahmenbedingungen, Entdeckung mit Nmap, Nmap-Skripte, CVE und CVSS, Scanner (Greenbone/OpenVAS, Nessus Essentials), authentifizierte Scans, Berichte, Priorisierung, Beheben und Nachweisen, Ausnahmen und Kennzahlen, Windows-Ziele und eine Abschlussrunde. 13 Module, 113 Unterrichtseinheiten zu 45 Minuten, davon 1 Modul mit Priorität 2 (Vertiefung). Die Aufgabentexte und Kontrollfragen stammen aus dem Lehrplan P15 (Reihe „Lehrplan-Prompts“, Datei `P15-schwachstellenmanagement.md`) und sind unverändert; Hinweise, Musterlösungen und Ergänzungen sind Teil der Ausarbeitung und gekennzeichnet.

> **Prüfstand, ehrlich:** **In einem Cloud-Container (Ubuntu 24.04) mit zwei Netzwerk-Namespaces ausgeführt, nicht unter Hyper-V, ohne Windows, ohne Greenbone und Nessus.** Die Skripte der Module 1 bis 5 und 7 bis 13 wurden mit Nmap 7.94SVN, nginx 1.24, OpenSSH 9.6p1 und Python 3 ausgeführt; Modul 6 (Scanner) ist reine Dokumentation. Die Ausgaben stehen in den Ordnern `beispiele/`. Die Beispieldaten (Funde, Hinweise, Ausnahmen, Verläufe) sind frei erfunden. Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Umgebung

Drei VMs unter **Hyper-V** (Lehrplan): `scan01` (`10.15.0.2`), `lx01` (`10.15.0.11`), `win01` (`10.15.0.12`) am privaten Switch `Lab-Scan` (`10.15.0.0/24`). Das Labor wurde **nicht** aufgebaut. Die Skripte bilden es mit zwei Netzwerk-Namespaces nach (`lab.sh`: Scanner `sc`, Ziel `lx`). Voraussetzungen im Testrechner: root, `ip`, `nmap`, `nginx`, `openssh-server`, `socat`, `openssl`, `python3`.

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [Prozess und Grundbegriffe](01-prozess-und-grundbegriffe/) | 6 h | Skript im Container ausgeführt. |
| 02 | [Rechtliche und organisatorische Rahmenbedingungen](02-recht-und-freigabe/) | 6 h | Skript im Container ausgeführt; rechtliche Aussagen nicht bestätigt. |
| 03 | [Labor und Entdeckung von Hosts und Diensten](03-labor-und-entdeckung/) | 6,75 h | Skript im Container ausgeführt. |
| 04 | [Nmap-Skripte und Befunde nach Regeln](04-nmap-skripte-und-befunde/) | 6,75 h | Skript im Container ausgeführt. |
| 05 | [CVE und CVSS](05-cve-und-cvss/) | 6,75 h | Skript im Container ausgeführt; Formeln nicht gegen die Spezifikation geprüft. |
| 06 | [Schwachstellenscanner: Greenbone/OpenVAS und Nessus Essentials](06-scanner-greenbone-und-nessus/) | 7,5 h | Nicht ausgeführt; Aussagen aus der Dokumentation (Greenbone 22.4, Nessus 10.10) und Fachwissen. |
| 07 | [Authentifizierte Scans und Paketprüfung](07-authentifizierte-scans/) | 6,75 h | Linux-Skript im Container ausgeführt; Windows nicht ausgeführt. |
| 08 | [Berichte erstellen und auswerten](08-berichte/) | 6 h | Skript im Container ausgeführt. |
| 09 | [Priorisierung nach Risiko](09-priorisierung/) | 6,75 h | Skript im Container ausgeführt; Gewichte sind Annahmen. |
| 10 | [Beheben, Gegenmaßnahmen und Nachweis](10-beheben-und-nachweisen/) | 6,75 h | Skript im Container ausgeführt; Windows nicht ausgeführt. |
| 11 | [Ausnahmen dokumentieren und Kennzahlen](11-ausnahmen-und-kennzahlen/) | 6 h | Skripte im Container ausgeführt; Daten erfunden. |
| 12 | [Windows-Ziele und Besonderheiten](12-windows-ziele/) (Priorität 2) | 5,25 h | Platzhalter-Dienste im Container; Windows nicht ausgeführt. |
| 13 | [Abschlussrunde und Fehlersuche](13-abschluss-und-fehlersuche/) | 7,5 h | Skript im Container ausgeführt; Windows nicht ausgeführt. |

Summe 84,75 Stunden.

## Aufbau eines Moduls

Ordner `NN-kurzname/` mit `README.md`, der Übung `NN.1-….md` (Lernziele, Voraussetzungen, Grundbegriffe, Aufgaben, Hinweise, Kontrollfragen, einklappbare Musterlösung, Erweiterungen, Quellen), den Skripten und Beispieldaten des Moduls und einem Ordner `beispiele/` mit den echten Ausgaben der Läufe. Die Skripte der Module liegen im jeweiligen Modulordner und binden `../lab.sh` ein.

## Hinweise

- Scannen Sie **ausschließlich Ihre eigenen Lab-Systeme**. Die Skripte scannen nur `10.15.0.0/24` in Namespaces; das Ziel wird absichtlich schwach konfiguriert (alte TLS-Protokolle, SSH mit Passwort, Dateiliste, Klartextdienst) und nur im Namespace erreichbar gemacht.
- Die Skripte starten nginx, sshd, einen Python-Webserver und `socat` in Namespaces und beenden sie wieder; nicht auf einem produktiven Rechner ausführen.
- Die Gewichte der Priorisierung und die Werte von EPSS und KEV in den Beispieldaten sind Annahmen bzw. erfunden.
- Der Versions-Scan (`-sV`) dauert wegen des absichtlich trägen Test-Dienstes auf Port 2323 einige Sekunden bis Minuten.

## Lizenz

- Skripte: MIT, siehe [`LICENSE`](LICENSE)
- Texte: CC BY 4.0, siehe [`LICENSE-DOCS.md`](LICENSE-DOCS.md)

*Lizenz: Text CC BY 4.0, Skripte MIT, siehe `LICENSE-DOCS.md` und `LICENSE` im Kursordner. Alle Personen, Firmen, Zahlen und Termine sind frei erfunden. Windows und Windows Server sind Marken der Microsoft Corporation; dieses Dokument steht in keiner Verbindung zu Microsoft.*
