# Passwort- und Secrets-Verwaltung (P63)

Übungsreihe zur Passwort- und Secrets-Verwaltung: Passwortstärke und Entropie, Passwort-Hashing, Richtlinien und Passphrasen, Tresor und Passwortmanager, Geheimnisse in Code und Git, Geheimnisse im Betrieb, verschlüsselte Geheimnisdateien mit age sowie Geheimnisdienste im Überblick. 8 Module, 90 Unterrichtseinheiten zu 45 Minuten, davon 1 Modul mit Priorität 2 (Vertiefung). Praxisübungen mit echten Läufen im Container; alle Geheimnisse sind erfunden. Die Aufgabentexte und Kontrollfragen stammen aus dem Lehrplan P63 (Reihe „Lehrplan-Prompts“, Datei `P63-passwort-und-secrets-verwaltung.md`) und sind unverändert; Hinweise, Musterlösungen und Ergänzungen sind Teil der Ausarbeitung und gekennzeichnet.

> **Prüfstand, ehrlich:** **Im Cloud-Container ausgeführt, nicht in Hyper-V.** Die Skripte liefen unter Ubuntu 24.04 mit Python 3, `git`, `gpg` und `age 1.1.1`; die Ausgaben stehen in den Ordnern `beispiele/`. Alle Geheimnisse sind erfunden. **OpenBao und HashiCorp Vault wurden nicht ausgeführt**; Modul 8 ist ein Python-Modell, `beispiel_cli.txt` nicht bestätigt. Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Umgebung

Eine Linux-VM unter **Hyper-V** (Lehrplan): `sec01` (`10.63.0.2`, Debian oder Ubuntu) am privaten Switch `Lab-Secrets` (`10.63.0.0/24`). Das Labor wurde **nicht** aufgebaut. Die Skripte arbeiten unter `/tmp/p63`.

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [Passwortstärke und Entropie](01-passwortstaerke-und-entropie/) | 9 h | Skript im Container ausgeführt. |
| 02 | [Passwort-Hashing](02-passwort-hashing/) | 9 h | Skript im Container ausgeführt. |
| 03 | [Passwort-Richtlinien und Passphrasen](03-passwort-richtlinien-und-passphrasen/) | 7,5 h | Skript im Container ausgeführt. |
| 04 | [Tresor und Passwortmanager](04-tresor-und-passwortmanager/) | 9 h | Skript im Container ausgeführt. |
| 05 | [Geheimnisse in Code und Git](05-geheimnisse-in-code-und-git/) | 9 h | Skript im Container ausgeführt. |
| 06 | [Geheimnisse im Betrieb](06-geheimnisse-im-betrieb/) | 9 h | Skript im Container ausgeführt. |
| 07 | [Verschlüsselte Geheimnisdateien mit age](07-verschluesselte-geheimnisdateien/) | 9 h | Skript im Container ausgeführt. |
| 08 | [Geheimnisdienste im Überblick](08-geheimnisdienste-im-ueberblick/) (Priorität 2) | 6 h | Modell ausgeführt; kein Produkt. |

Summe 67,5 Stunden.

## Aufbau eines Moduls

Ordner `NN-kurzname/` mit `README.md`, der Übung `NN.1-….md` (Lernziele, Voraussetzungen, Grundbegriffe, Aufgaben, Hinweise, Kontrollfragen, einklappbare Musterlösung, Erweiterungen, Quellen), den Skripten und Beispieldaten des Moduls und einem Ordner `beispiele/` mit den echten Ausgaben der Läufe. Die Skripte der Module liegen im jeweiligen Modulordner und binden `../lab.sh` ein.

## Hinweise

- Die Skripte legen Dateien nur unter `/tmp/p63` an und räumen auf; `gpg` nutzt ein eigenes `GNUPGHOME` dort.
- Verwenden Sie in Übungen **nie echte** Passwörter oder Schlüssel; alle Werte sind erfunden.
- Die Textdatei `beispiel_cli.txt` wurde nicht ausgeführt und nicht gegen die Dokumentation geprüft.

## Lizenz

- Skripte: MIT, siehe [`LICENSE`](LICENSE)
- Texte: CC BY 4.0, siehe [`LICENSE-DOCS.md`](LICENSE-DOCS.md)

*Lizenz: Text CC BY 4.0, Skripte MIT, siehe `LICENSE-DOCS.md` und `LICENSE` im Kursordner. Alle Personen, Firmen, Zahlen und Termine sind frei erfunden. Windows und Windows Server sind Marken der Microsoft Corporation; dieses Dokument steht in keiner Verbindung zu Microsoft.*
