# IT-Sicherheit – Übungsreihen

Praxisübungen zur IT-Sicherheit mit Windows und Linux im isolierten Labor. Jede Reihe liegt in einem eigenen Ordner mit Modulen, Material und Skripten.

## Reihen

| Ordner | Thema | Stand |
|---|---|---|
| [`it-sicherheitsgrundlagen/`](it-sicherheitsgrundlagen/) | IT-Sicherheitsgrundlagen (P12): 12 Module, 87 Stunden | Entwurf, Linux-Teile in einer Testumgebung ausgeführt, Windows nicht |
| [`kryptografie-zertifikate-und-tls/`](kryptografie-zertifikate-und-tls/) | Kryptografie, Zertifikate und TLS (P16): 12 Module, 82,5 Stunden | Entwurf, OpenSSL-, TLS- und LUKS-Verwaltungsbefehle in einer Testumgebung ausgeführt, Windows nicht |
| [`windows-server-haertung/`](windows-server-haertung/) | Windows-Server-Härtung (P13): 13 Module, 83,25 Stunden | Entwurf, nichts auf Windows ausgeführt; Auswertungsskripte (Python) mit erfundenen Daten im Container |
| [`linux-server-haertung/`](linux-server-haertung/) | Linux-Server-Härtung (P14): 13 Module, 84 Stunden | Entwurf, Skripte in einer Testumgebung (Container) ausgeführt |
| [`schwachstellenmanagement/`](schwachstellenmanagement/) | Schwachstellenmanagement (P15): 13 Module, 84,75 Stunden | Entwurf, Nmap-Scans in einer Testumgebung ausgeführt; Greenbone/Nessus und Windows nicht |
| [`ids-und-ips-mit-suricata/`](ids-und-ips-mit-suricata/) | IDS und IPS mit Suricata (P62): 8 Module, 100 Unterrichtseinheiten | Entwurf, Skripte im Container mit Suricata 7.0.3 (Offline-Modus, Mitschnitte von Loopback) ausgeführt; Inline-Betrieb (IPS), `suricata-update` und Hyper-V nicht ausgeführt |
| [`passwort-und-secrets-verwaltung/`](passwort-und-secrets-verwaltung/) | Passwort- und Secrets-Verwaltung (P63): 8 Module, 90 Unterrichtseinheiten | Entwurf, Skripte im Container mit `git`, `gpg` und `age` ausgeführt; OpenBao und Vault nicht ausgeführt (Modell), Hyper-V nicht |
| [`penetrationstest-grundlagen/`](penetrationstest-grundlagen/) | Penetrationstest-Grundlagen (P64): 8 Module, 100 Unterrichtseinheiten | Entwurf, Skripte im Container mit nmap 7.94SVN und curl nur gegen `127.0.0.1` ausgeführt; Netzscans, Metasploit, Burp Suite, Schwachstellenscanner und Hyper-V nicht |

## Lizenz

- Skripte: MIT, siehe [`LICENSE`](LICENSE)
- Texte: CC BY 4.0, siehe [`LICENSE-DOCS.md`](LICENSE-DOCS.md)

Microsoft, Windows und Hyper-V sind Marken der Microsoft Corporation, Ubuntu ist eine Marke von Canonical Ltd., Nessus eine Marke von Tenable, Inc. Dieses Repository steht in keiner Verbindung zu den Markeninhabern. Der Teststatus jeder Reihe steht in deren README.
