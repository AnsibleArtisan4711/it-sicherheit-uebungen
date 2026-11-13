# IT-Sicherheitsgrundlagen (P12)

Übungsreihe zu Schutzzielen, Bedrohungen, Kryptografie, Zugriffsverwaltung, Netzwerksicherheit, Härtung, sicherer Konfiguration (SSH, RDP, TLS), Risikomanagement, Richtlinien, Logging, Vorfallbehandlung und einer abschließenden Sicherheitsprüfung. Zwölf Module mit je einer ausgearbeiteten Übung (Steckbrief, Lernziele, Voraussetzungen, Grundbegriffe, Aufgaben mit Bezug zu den Lerneinheiten, Hinweise, Kontrollfragen, Musterlösung, Erweiterungen, Quellen). Gesamtumfang laut Lehrplan: 116 Unterrichtseinheiten.

> **Prüfstand, ehrlich:** **Teilweise in einer Testumgebung ausgeführt, nicht unter Hyper-V und nicht auf Windows.** Die Linux-Befehle der Module 3, 4, 5, 7, 10 und 12 sowie die Python-Skripte (Module 2, 8, 10) wurden in Netzwerk-Namespaces eines Cloud-Containers (Ubuntu 24.04.5) ausgeführt; der Windows-Server in Modul 12 wurde mit nftables nachgebildet. **Nicht geprüft:** alle Windows-Befehle (PowerShell, `icacls`, `net use`, Gruppenrichtlinien, Ereignisanzeige, RDP), Hyper-V, Apache, Wireshark, systemd, `auth.log`. Die Module 1, 9 und 11 sind Fallstudien ohne Labor, Modul 6 wurde fast nur beschrieben. Die Ausgaben im Ordner `beispiele/` der Module stammen aus der Testumgebung. Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Umgebung

Drei VMs unter **Hyper-V** (Lehrplan): `VM-WIN-SRV` (Windows Server 2022 Eval, `192.168.50.10`), `VM-LINUX` (Ubuntu 24.04, `192.168.50.20`) und `VM-WIN-CLIENT` (Windows 11 Enterprise Eval, `192.168.50.30`) am privaten Switch `vSwitch-Sec-Privat` (`192.168.50.0/24`, ohne Gateway, ohne Heimnetz, ohne Active Directory). Software (Wireshark, Nmap, SSH-Server, Apache) wird vor Modul 3 einmalig mit Internetzugang installiert, siehe Lehrplan. Das Labor wurde **nicht** aufgebaut; getestet wurde in Namespaces (siehe `testlabor-namespaces.sh`).

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [Einführung in die IT-Sicherheit & Schutzziele](01-schutzziele/) | 4,5 h | Entwurf, ohne Labor (Fallstudie) |
| 02 | [Bedrohungslandschaft & Angriffsarten](02-bedrohungen/) | 7,5 h | Entwurf, Skript in Testumgebung ausgeführt |
| 03 | [Grundlagen der Kryptografie](03-kryptografie/) | 7,5 h | Entwurf, teilweise in Testumgebung ausgeführt |
| 04 | [Identitäts- und Zugriffsverwaltung (IAM)](04-identitaet-und-zugriff/) | 7,5 h | Entwurf, teilweise in Testumgebung ausgeführt |
| 05 | [Netzwerksicherheit & Segmentierung](05-netzwerksicherheit/) | 9 h | Entwurf, teilweise in Testumgebung ausgeführt |
| 06 | [Endgerätesicherheit & Härtung](06-endgeraetesicherheit/) | 9 h | Entwurf, überwiegend nicht ausgeführt |
| 07 | [Sichere Anwendungs- und Dienstkonfiguration](07-sichere-dienste/) | 7,5 h | Entwurf, teilweise in Testumgebung ausgeführt |
| 08 | [Risikomanagement & Schwachstellenbewertung](08-risikomanagement/) (Priorität 2) | 6 h | Entwurf, Skripte in Testumgebung ausgeführt |
| 09 | [Sicherheitsrichtlinien, Compliance & Awareness](09-richtlinien-und-awareness/) (Priorität 2) | 6 h | Entwurf, ohne Labor (Fallstudie) |
| 10 | [Überwachung, Logging & Diagnosewerkzeuge](10-logging-und-diagnose/) | 9 h | Entwurf, teilweise in Testumgebung ausgeführt |
| 11 | [Vorfallbehandlung (Incident Response) & Notfallplanung](11-vorfallbehandlung/) | 6 h | Entwurf, ohne Labor (Fallstudie) |
| 12 | [Praktische Sicherheitsprüfung & Troubleshooting](12-sicherheitspruefung/) (Priorität 2) | 7,5 h | Entwurf, teilweise in Testumgebung ausgeführt |

Summe 87 Stunden.

## Aufbau eines Moduls

Ordner `NN-kurzname/` mit `README.md`, der Übung `NN.1-….md`, gegebenenfalls Material und Skripten und einem Ordner `beispiele/` mit Ausgaben der Testumgebung. Das Hilfsskript [`testlabor-namespaces.sh`](testlabor-namespaces.sh) baut das Drei-VM-Labor ohne Hyper-V in Namespaces nach; es ist nicht Teil des Lehrplans. Das Material der Module 1, 2, 8 und 10 (Szenario, E-Mails, Bericht, Logauszug) ist frei erfunden und fehlte im Lehrplan.

## Hinweise

- Nur im Labor ausführen; die Übungen verändern Firewall-Regeln, Berechtigungen und SSH-Einstellungen. Port-Scans nur gegen die eigenen Lab-VMs.
- Schlüssel und Kennwörter gehören nie in ein Repository. Die Schlüssel in den Beispielen sind Test-Schlüssel.
- Alle Firmen, Namen, Adressen und Berichte sind frei erfunden (Domänen nach RFC 2606, Adressen nach RFC 1918 und RFC 5737, Kennungen `FIKTIV-2026-000N`).
- Rechts- und Normaussagen sind Fachwissen und keine Rechtsberatung.

## Lizenz

- Skripte: MIT, siehe [`LICENSE`](LICENSE)
- Texte: CC BY 4.0, siehe [`LICENSE-DOCS.md`](LICENSE-DOCS.md)
