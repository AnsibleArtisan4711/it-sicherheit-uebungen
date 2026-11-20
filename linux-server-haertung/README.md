# Linux-Server-Härtung (P14)

Übungsreihe zur Härtung eines Debian/Ubuntu-Servers: Baselines und Messung, Konten, PAM, sudo, SSH, Dienste und Kernel-Parameter, Dateirechte und Mount-Optionen, AppArmor/SELinux, Host-Firewall, Protokollierung mit auditd, automatische Updates, Integritätsprüfung und Fail2ban sowie Prüfung und Fehlersuche. 13 Module, 112 Unterrichtseinheiten zu 45 Minuten, davon 1 Modul mit Priorität 2 (Vertiefung). Die Aufgabentexte und Kontrollfragen stammen aus dem Lehrplan P14 (Reihe „Lehrplan-Prompts“, Datei `P14-linux-server-haertung.md`) und sind unverändert; Hinweise, Musterlösungen und Ergänzungen sind Teil der Ausarbeitung und gekennzeichnet.

> **Prüfstand, ehrlich:** **In einem Cloud-Container (Ubuntu 24.04) ausgeführt, nicht unter Hyper-V, nicht auf Debian 12, ohne systemd.** Die Skripte der Module 1 bis 7 und 9 bis 13 wurden mit Lynis 3.0.9, OpenSSH 9.6p1, sudo 1.9.15p5, auditd 3.1.2, AIDE 0.18.6, fail2ban 1.0.2, ssh-audit 3.9.0 und nftables 1.0.9 ausgeführt, Modul 8 nur auf Syntax (AppArmor und SELinux sind im Test-Kernel nicht aktiv). Die Ausgaben stehen in den Ordnern `beispiele/`. Handbücher, CIS Benchmarks und Herstellerleitfäden wurden nicht gelesen. Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Umgebung

Eine bis zwei VMs unter **Hyper-V** (Lehrplan): `vm01` (Debian 12 oder Ubuntu Server 24.04 LTS, `10.14.0.1`) und `cl01` (Verwaltungsrechner, `10.14.0.2`) am privaten Switch `Lab-Haertung` (`10.14.0.0/24`). Das Labor wurde **nicht** aufgebaut. Die Skripte bilden es mit zwei Netzwerk-Namespaces (`lab.sh`: `on srv …`, `on cl …`) nach und ändern teilweise Dateien unter `/etc` des Testrechners; sie räumen auf. Voraussetzungen im Testrechner: root, `ip`, `nft`, `sshd`, `lynis`, `auditd`, `acl`, `libpam-pwquality`, `libpwquality-tools`, `pamtester`, `apparmor`, `aide`, `fail2ban`, `unattended-upgrades`, `ssh-audit` (pip), `python3.12` mit `apt_pkg` (Modul 11), `curl`, `nc`.

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [Härtungskonzept, Baselines und Labor](01-haertungskonzept-und-baselines/) | 6 h | Skript im Container ausgeführt. |
| 02 | [Benutzer, Gruppen und Konten](02-benutzer-und-konten/) | 6,75 h | Skript im Container ausgeführt. |
| 03 | [PAM: Passwortqualität und Kontosperre](03-pam/) | 6,75 h | Skript im Container ausgeführt. |
| 04 | [sudo: Rechte vergeben und protokollieren](04-sudo/) | 6 h | Skript im Container ausgeführt. |
| 05 | [SSH-Härtung](05-ssh-haertung/) | 7,5 h | Skript im Container ausgeführt. |
| 06 | [Dienste, Pakete und Kernel-Parameter](06-dienste-pakete-kernelparameter/) | 6,75 h | Skript im Container ausgeführt (ohne systemd). |
| 07 | [Dateirechte, ACLs und Mount-Optionen](07-dateirechte-acl-mountoptionen/) | 6,75 h | Skript im Container ausgeführt. |
| 08 | [Mandatory Access Control: AppArmor und SELinux](08-mac-apparmor-selinux/) | 6 h | Syntax geprüft, Durchsetzung nicht (Kernel ohne AppArmor und SELinux). |
| 09 | [Host-Firewall für den Server](09-host-firewall-server/) | 5,25 h | Skript im Container ausgeführt. |
| 10 | [Protokollierung und auditd](10-protokollierung-und-auditd/) | 7,5 h | Skript im Container ausgeführt (auditd ohne systemd). |
| 11 | [Updates und automatische Sicherheitsupdates](11-automatische-updates/) | 6 h | Skript im Container ausgeführt (Probelauf, ohne systemd-Timer). |
| 12 | [Integritätsprüfung (AIDE) und Schutz vor Dauerangriffen (fail2ban)](12-integritaet-und-zusatzschutz/) (Priorität 2) | 5,25 h | Skript im Container ausgeführt (kein Jail getestet). |
| 13 | [Härtung prüfen, Fehlersuche und Abschlussprojekt](13-haertung-pruefen-und-abschluss/) | 7,5 h | Skripte im Container ausgeführt (Fehlersuche nicht als Skript). |

Summe 84 Stunden.

## Aufbau eines Moduls

Ordner `NN-kurzname/` mit `README.md`, der Übung `NN.1-….md` (Lernziele, Voraussetzungen, Grundbegriffe, Aufgaben, Hinweise, Kontrollfragen, einklappbare Musterlösung, Erweiterungen, Quellen), den Skripten und Beispieldaten des Moduls und einem Ordner `beispiele/` mit den echten Ausgaben der Läufe. Die Skripte der Module liegen im jeweiligen Modulordner und binden `../lab.sh` ein.

## Hinweise

- Nur im Testlabor ausführen: Die Skripte legen Konten mit dem Präfix `t14` an (`/etc/passwd`), ändern `/etc/login.defs`, `/etc/issue`, `/etc/ssh/sshd_config.d` und andere Dateien (`haertung_anwenden.sh` sichert und stellt sie wieder her), starten auditd und laden Audit-Regeln. **Nicht auf einem produktiven Rechner und nicht auf `vm01` ungeprüft ausführen**; dort die Befehle der Aufgaben einzeln eingeben.
- Kein Skript setzt Kernel-Parameter des Rechners (`sysctl -p`); Netzwerk-Parameter werden nur im Namespace gesetzt.
- Vor Änderungen an SSH, PAM, sudo und Firewall einen Prüfpunkt anlegen und eine zweite Sitzung offen halten.
- Der Härtungsindex von Lynis und die Zahlen in den Ausgaben gelten für den Testrechner; auf `vm01` fallen sie anders aus.

## Lizenz

- Skripte: MIT, siehe [`LICENSE`](LICENSE)
- Texte: CC BY 4.0, siehe [`LICENSE-DOCS.md`](LICENSE-DOCS.md)

*Lizenz: Text CC BY 4.0, Skripte MIT, siehe `LICENSE-DOCS.md` und `LICENSE` im Kursordner. Alle Personen, Firmen, Zahlen und Termine sind frei erfunden. Windows und Windows Server sind Marken der Microsoft Corporation; dieses Dokument steht in keiner Verbindung zu Microsoft.*
