# Windows-Server-Härtung (P13)

Übungsreihe zur Härtung von Windows Server: Baselines und Security Compliance Toolkit, Tier-Modell, Gruppenrichtlinien, Konten- und Kennwortrichtlinien, Dienste und Rollen, Defender und Firewall, Windows LAPS, Überwachung und Ereignisauswertung, Patch-Management, Fernzugriff und Protokolle, Zusatzschutz sowie Prüfung und Fehlersuche. 13 Module, 111 Unterrichtseinheiten zu 45 Minuten, davon 1 Modul mit Priorität 2 (Vertiefung). Die Aufgabentexte und Kontrollfragen stammen aus dem Lehrplan P13 (Reihe „Lehrplan-Prompts“, Datei `P13-windows-server-haertung.md`) und sind unverändert; Hinweise, Musterlösungen und Ergänzungen sind Teil der Ausarbeitung und gekennzeichnet.

> **Prüfstand, ehrlich:** **Unter Linux (Python 3, Cloud-Container) mit erfundenen Beispieldaten ausgeführt, nicht unter Windows und nicht in Hyper-V.** Die Skripte der Module 1 bis 11 und 13 lesen mitgelieferte Exportdateien (CSV, INF) und geben Prüfergebnisse aus; Modul 12 enthält kein Skript. Die Ausgaben stehen in den Ordnern `beispiele/`. Die Aussagen im Text stammen teils aus gelesenen Microsoft-Learn-Auszügen (siehe Lehrplan, Quellen), teils aus Fachwissen und sind in der Übung entsprechend gekennzeichnet. Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Umgebung

Zwei VMs unter **Hyper-V** (Lehrplan): `srv01` (Windows Server 2022 oder 2025, `10.13.0.10`) und `cl01` (Windows 11, `10.13.0.20`) am privaten Switch `Lab-WinHaertung` (`10.13.0.0/24`). Das Labor wurde **nicht** aufgebaut. Voraussetzungen für die Beispielskripte: `python3` (3.8 oder neuer); sie benötigen keine zusätzlichen Pakete und ändern nichts am Rechner.

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [Härtungskonzept und Sicherheitsbaselines](01-haertungskonzept-und-baselines/) | 6 h | Skript im Container mit erfundenen Daten ausgeführt; Windows nicht ausgeführt. |
| 02 | [Tier-Modell und Administrationskonten](02-tier-modell-und-administration/) | 6,75 h | Skript im Container ausgeführt; Konzept aus Dokumentation. |
| 03 | [Lokale Richtlinien und Gruppenrichtlinien](03-lokale-richtlinien-und-gpo/) | 7,5 h | Modell im Container ausgeführt; Befehle nicht bestätigt. |
| 04 | [Konten, Kennwort- und Sperrrichtlinien](04-konten-und-kennwortrichtlinien/) | 6 h | Skript im Container ausgeführt; Windows nicht ausgeführt. |
| 05 | [Dienste und Rollen reduzieren](05-dienste-und-rollen/) | 6 h | Skript im Container ausgeführt; Windows nicht ausgeführt. |
| 06 | [Microsoft Defender und Windows-Firewall](06-defender-und-firewall/) | 6,75 h | Skript im Container ausgeführt; Windows nicht ausgeführt; Defender-Aussagen Fachwissen. |
| 07 | [Anmeldeschutz: Windows LAPS und lokale Konten](07-anmeldeschutz-laps/) | 6,75 h | Skript im Container ausgeführt; Windows LAPS nicht ausgeführt; Aussagen aus der Dokumentation. |
| 08 | [Überwachungsrichtlinie und Protokollierung](08-ueberwachung-und-protokollierung/) | 6,75 h | Skript im Container ausgeführt; `auditpol` nicht ausgeführt. |
| 09 | [Ereignisse auswerten und Angriffe erkennen](09-ereignisse-auswerten/) | 6 h | Skript im Container mit erfundenen Daten ausgeführt. |
| 10 | [Patch-Management](10-patch-management/) | 6 h | Skript im Container ausgeführt; Update-Wege nicht bestätigt. |
| 11 | [Fernzugriff und Protokolle: RDP, SMB, NTLM, WinRM](11-fernzugriff-und-protokolle/) | 6 h | Skript im Container ausgeführt; Aussagen Fachwissen. |
| 12 | [Zusatzschutz: Credential Guard, Anwendungskontrolle, Secure Boot](12-zusatzschutz/) (Priorität 2) | 5,25 h | Nicht ausgeführt; Credential Guard aus Dokumentation, Rest Fachwissen. |
| 13 | [Härtung prüfen, dokumentieren und Fehlersuche](13-pruefen-dokumentieren-und-fehlersuche/) | 7,5 h | Skript im Container ausgeführt; Windows nicht ausgeführt. |

Summe 83,25 Stunden.

## Aufbau eines Moduls

Ordner `NN-kurzname/` mit `README.md`, der Übung `NN.1-….md` (Lernziele, Voraussetzungen, Grundbegriffe, Aufgaben, Hinweise, Kontrollfragen, einklappbare Musterlösung, Erweiterungen, Quellen), den Skripten und Beispieldaten des Moduls und einem Ordner `beispiele/` mit den echten Ausgaben der Läufe. Die Skripte der Module liegen im jeweiligen Modulordner; `lauf.sh` führt sie mit den Beispieldaten aus.

## Hinweise

- Alle Daten in den Beispieldateien sind **erfunden**; die Skripte lesen nur und ändern nichts.
- Für echte Prüfungen eigene Exporte verwenden (z. B. `auditpol ... /r`, Dienste- und Konten-Listen) und die Spalten der Skripte anpassen.
- Prüfpunkte auf einem Domänencontroller sind riskant; vor Richtlinienänderungen eine Sicherung des Systemzustands anlegen.
- Die CIS Benchmarks sind nicht Bestandteil dieser Reihe; Nummerierung und Maßnahmen wurden nicht übernommen.

## Lizenz

- Skripte: MIT, siehe [`LICENSE`](LICENSE)
- Texte: CC BY 4.0, siehe [`LICENSE-DOCS.md`](LICENSE-DOCS.md)

*Lizenz: Text CC BY 4.0, Skripte MIT, siehe `LICENSE-DOCS.md` und `LICENSE` im Kursordner. Alle Personen, Firmen, Zahlen und Termine sind frei erfunden. Windows und Windows Server sind Marken der Microsoft Corporation; dieses Dokument steht in keiner Verbindung zu Microsoft.*
