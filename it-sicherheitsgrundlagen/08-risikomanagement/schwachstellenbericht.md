# Schwachstellenbericht (frei erfunden)

Auszug aus einem fiktiven Scan der Firma `example.org`. Die Kennungen `FIKTIV-2026-000N` sind **keine echten CVE-Nummern**; Produkte und Versionen sind erfunden. Der Basiswert steht bewusst nicht in der Tabelle: Du berechnest ihn aus dem Vektor (`python3 cvss31.py`).

| Kennung | System | Beschreibung | Basisvektor (CVSS 3.1) |
|---|---|---|---|
| FIKTIV-2026-0001 | `web01`, öffentlicher Webserver (DMZ, aus dem Internet erreichbar) | Fehler in der Dateiablage der Verwaltungsoberfläche: ohne Anmeldung lassen sich Konfigurationsdateien lesen und ersetzen | `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:N` |
| FIKTIV-2026-0002 | `print01`, interner Druckserver (nur im Büro-VLAN erreichbar, keine personenbezogenen Daten, per Firewall von Server-VLAN getrennt) | Fehler im Netzwerkdienst des Druckservers: Codeausführung ohne Anmeldung aus dem lokalen Netz | `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H` |
| FIKTIV-2026-0003 | `file01`, interner Dateiserver (enthält Personaldaten der Abteilung HR) | Fehler in einem lokalen Hilfsprogramm: angemeldeter Benutzer ohne Adminrechte kann Rechte ausweiten | `CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H` |

Zusatzangaben des Berichts: Für FIKTIV-2026-0001 ist ein öffentlich beschriebener Angriff bekannt (fiktiv). Für 0002 und 0003 sind keine Angriffe bekannt. Ein Patch steht für alle drei zur Verfügung; der Dateiserver darf nur in einem Wartungsfenster am Wochenende neu gestartet werden.
