# Kryptografie, Zertifikate und TLS (P16)

Übungsreihe zu symmetrischer und asymmetrischer Verschlüsselung, Hashes und HMAC, digitalen Signaturen, X.509-Zertifikaten und Vertrauensketten, dem Aufbau einer lokalen CA mit OpenSSL, dem TLS-Handshake (mit Mitschnitten), der Fehlersuche bei Zertifikaten, der Verschlüsselung ruhender Daten (LUKS, BitLocker) und dem Passwort-Hashing. Zwölf Module, 110 Unterrichtseinheiten zu 45 Minuten, davon 2 Module mit Priorität 2 (Vertiefung). Die Aufgabentexte und Kontrollfragen stammen aus dem Lehrplan P16 (Reihe „Lehrplan-Prompts“) und sind unverändert; Hinweise, Musterlösungen und Ergänzungen sind Teil der Ausarbeitung und gekennzeichnet.

> **Prüfstand, ehrlich:** **Teilweise in einer Testumgebung ausgeführt, nicht unter Hyper-V und nicht auf Windows.** Die OpenSSL-Befehle der Module 2 bis 7, 9 und 12, die TLS-Mitschnitte (Modul 8, `tshark`) und die LUKS-Verwaltungsbefehle (Modul 10, an einem Loop-Gerät) wurden in einem Cloud-Container (Ubuntu 24.04, OpenSSL 3.0.13, curl 8.5.0, TShark 4.2.2, cryptsetup 2.7.0, zwei Netzwerk-Namespaces) ausgeführt; Windows 11 wurde durch einen Linux-Namespace mit `curl` ersetzt. **Nicht geprüft:** alle Windows-Teile (`certlm.msc`, `certutil`, `Import-Certificate`, Browser, `curl.exe` mit Schannel, BitLocker in Modul 11), Hyper-V, `scp` zwischen den VMs und das Öffnen, Formatieren und Einhängen eines LUKS-Containers (Modul 10, Aufgabe 2). Modul 1 ist eine Fallstudie (die BSI-Richtlinie wurde nicht inhaltlich gelesen), Modul 11 wurde nicht ausgeführt (Befehlssyntax auf Microsoft Learn gegengelesen). Die Ausgaben im Ordner `beispiele/` der Module stammen aus der Testumgebung. Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Umgebung

Zwei VMs unter **Hyper-V** (Lehrplan): `linux01` (Debian 12 oder Ubuntu Server mit OpenSSL 3.x, `192.168.10.10`; Pakete `openssl`, `ca-certificates`, `cryptsetup`, `tshark`, `openssh-server`; zusätzliche leere Platte ab Modul 10) und `win11-01` (Windows 11 Pro/Enterprise/Education, `192.168.10.20`; zusätzliche leere Platte ab Modul 11) am privaten Switch `Lab-Internal-Net` (`192.168.10.0/24`, statisch, kein DHCP, kein DNS). Die Pakete werden vor Kursbeginn einmalig mit Internetzugang installiert (Details im Lehrplan). Das Labor wurde **nicht** aufgebaut; getestet wurde in Namespaces (siehe `testlabor16.sh`).

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [Grundlagen der Kryptografie](01-grundlagen-der-kryptografie/) | 6 h | Entwurf, Fallstudie (Caesar-Beispiel im Testlabor ausgeführt) |
| 02 | [Symmetrische Verschlüsselung](02-symmetrische-verschluesselung/) | 7,5 h | Entwurf, Befehle in Testumgebung ausgeführt |
| 03 | [Asymmetrische Verschlüsselung](03-asymmetrische-verschluesselung/) | 7,5 h | Entwurf, Befehle in Testumgebung ausgeführt |
| 04 | [Hashes und Message Authentication Codes](04-hashes-und-mac/) | 6 h | Entwurf, Befehle in Testumgebung ausgeführt |
| 05 | [Digitale Signaturen](05-digitale-signaturen/) | 6 h | Entwurf, Befehle in Testumgebung ausgeführt |
| 06 | [Zertifikate und Vertrauenskette (PKI)](06-zertifikate-und-vertrauenskette/) | 7,5 h | Entwurf, Befehle in Testumgebung ausgeführt |
| 07 | [OpenSSL in der Praxis (lokale CA)](07-openssl-lokale-ca/) | 9 h | Entwurf, Befehle in Testumgebung ausgeführt |
| 08 | [Der TLS-Handshake](08-tls-handshake/) | 7,5 h | Entwurf, Linux-Teile in Testumgebung ausgeführt, Windows nicht |
| 09 | [Zertifikatsprüfung und Fehlersuche in TLS](09-zertifikatspruefung-und-fehlersuche/) | 7,5 h | Entwurf, Linux-Teile in Testumgebung ausgeführt, Windows nicht |
| 10 | [Verschlüsselung ruhender Daten: LUKS](10-luks/) (Priorität 2) | 6 h | Entwurf, Verwaltungsbefehle in Testumgebung ausgeführt; Öffnen und Einhängen nicht |
| 11 | [Verschlüsselung ruhender Daten: BitLocker](11-bitlocker/) (Priorität 2) | 6 h | Entwurf, ohne Labor (Windows nicht ausgeführt) |
| 12 | [Passwörter und Hashing](12-passwoerter-und-hashing/) | 6 h | Entwurf, Befehle in Testumgebung ausgeführt |

Summe 82,5 Stunden.

## Aufbau eines Moduls

Ordner `NN-kurzname/` mit `README.md`, der Übung `NN.1-….md` (Lernziele, Voraussetzungen, Grundbegriffe, Aufgaben, Hinweise, Kontrollfragen, einklappbare Musterlösung, Erweiterungen, Quellen) und einem Ordner `beispiele/` mit Ausgaben der Testumgebung. Das Hilfsskript [`testlabor16.sh`](testlabor16.sh) baut `linux01` und `win11-01` ohne Hyper-V in zwei Netzwerk-Namespaces nach; es ist nicht Teil des Lehrplans.

## Arbeitsverzeichnis

Auf `linux01` arbeitet jedes Modul im Ordner `~/krypto/mNN/`; spätere Module greifen auf frühere zu (Modul 5 auf die Schlüssel aus Modul 3, Modul 8 und 9 auf CA und Server-Zertifikat aus Modul 7). Der Ordner wird nicht gelöscht.

## Hinweise

- Nur im Labor ausführen. Schlüssel und Kennwörter gehören nie in ein Repository; die Schlüssel in den Beispielen sind Testschlüssel, die Kennwörter (`LabKennwort1`, `Kurs2026!`) Laborwerte.
- `luksFormat` und `dd` zerstören Daten: Gerätenamen mit `lsblk` prüfen und vorher einen Prüfpunkt anlegen.
- `ca.key` verlässt `linux01` nie.
- Alle Namen und Adressen sind frei erfunden (`example.internal`, Adressen nach RFC 1918).
- Aussagen zu Normen und Empfehlungen sind Fachwissen und keine Rechtsberatung; die BSI-Richtlinie wurde nicht inhaltlich gelesen.

## Lizenz

- Skripte: MIT, siehe [`LICENSE`](LICENSE)
- Texte: CC BY 4.0, siehe [`LICENSE-DOCS.md`](LICENSE-DOCS.md)
