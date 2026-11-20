# Befehle und Aussagen, die nicht bestätigt sind

Prüfliste für den ersten Durchlauf in den Hyper-V-VMs: Befund und Datum eintragen, danach den Hinweis in der Übung entfernen. Legende: **Q** = gegen Quelle gelesen; **L** = im Labor (Container) ausgeführt; **–** = weder noch.

| Modul | Befehl oder Aussage | Status | Nächster Schritt |
|---|---|---|---|
| alle | Aufbau des Hyper-V-Labors (privater Switch `Lab-Scan`, `scan01`, `lx01`, `win01`) | – | laut Lehrplan aufbauen und prüfen |
| 01 | Zustandsautomat `lebenszyklus.py` (Zustände und Übergänge sind eigene Festlegungen) | L (Python 3) | mit den Zuständen des Betriebs abgleichen |
| 02 | `scan_freigabe.py` (Freigabe-Prüfung, Stichtag fest); rechtliche Aussagen (§ 118a StGB u. a.) | L; Recht – (Fachwissen, nicht gelesen) | Rechtslage durch Fachkundige prüfen lassen |
| 03 | `nmap -sn`, `-sS -p-`, `-sV`, `--exclude`, `-oX` | L (Nmap 7.94SVN) | in Hyper-V gegen `lx01` und `win01` wiederholen |
| 04 | NSE: `ssl-enum-ciphers`, `ssh-auth-methods`, `http-title`, `http-headers`, `banner`; Regeln R1 bis R6 | L | in Hyper-V wiederholen; weitere Regeln |
| 05 | CVSS-3.1-Basiswert (`cvss_rechner.py`), sechs Testvektoren | L; Formeln nicht gegen die Spezifikation geprüft | mit dem FIRST-Rechner und der Spezifikation vergleichen |
| 06 | Greenbone Community Containers (Docker Compose, Feed `24.10`, Konto `admin`/`admin`) und Nessus Essentials (16 Hosts) | – (nur Dokumentation gelesen, nicht ausgeführt) | auf `scan01` einrichten und Scan durchführen |
| 07 | `paketpruefung.py` mit `dpkg --compare-versions` (erfundene Hinweise) | L (Ubuntu 24.04) | in Debian 12 wiederholen; echte Hinweise verwenden |
| 07 | Authentifizierte Scans auf Windows (WinRM, SMB, Remote-UAC) | – (Fachwissen) | in `win01` ausprobieren |
| 08 | `bericht_auswerten.py` mit erfundenen Beispieldaten | L | mit echtem Scanner-Export (CSV) testen |
| 09 | `priorisieren.py` (eigene Gewichte, Fristen P1 bis P4) | L; Gewichte sind Annahmen | mit den Regeln des Betriebs abgleichen |
| 10 | `behebung_nachweis.sh` mit `scan_vergleich.py` (Ziel im gehärteten Zustand neu gestartet) | L | in Hyper-V mit Prüfpunkt und echter Änderung wiederholen |
| 11 | `ausnahmen_pruefen.py`, `kennzahlen.py` (Stichtag fest, Daten erfunden) | L | mit eigenem Register prüfen |
| 12 | `windows_ports.sh` (Platzhalter-Dienste), Bedeutung der Windows-Ports | L (Platzhalter); Windows – | gegen `win01` wiederholen |
| 13 | `abschluss_runde.sh` (EPSS 0,05 und KEV „nein“ angenommen) | L | in Hyper-V wiederholen |
