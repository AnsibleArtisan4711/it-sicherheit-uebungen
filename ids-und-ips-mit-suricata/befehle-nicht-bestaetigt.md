# Befehle und Aussagen, die nicht bestätigt sind

Prüfliste für den ersten Durchlauf in den Hyper-V-VMs: Befund und Datum eintragen, danach den Hinweis in der Übung entfernen. Legende: **Q** = gegen Quelle gelesen; **L** = im Labor (Container) ausgeführt; **–** = weder noch.

| Modul | Befehl oder Aussage | Status | Nächster Schritt |
|---|---|---|---|
| alle | Aufbau des Hyper-V-Labors (privater Switch `Lab-IDS`, `ids01`), Installation von Suricata | – | laut Lehrplan aufbauen und prüfen |
| 01 | `suricata -V`, `--build-info`, `-T`, `-r`, `-l`, `-k none`; `tcpdump -w` | L (Suricata 7.0.3, Offline) | auf `ids01` wiederholen |
| 02 | Regelsyntax (`content`, `flow`, `http.uri`, `startswith`, `nocase`, `http.stat_code`); Fehlermeldungen von `-T` | L | auf `ids01` wiederholen |
| 03 | Offline-Auswertung, `tcpdump -r`, Flows in `eve.json` | L (Loopback-Verkehr) | mit Verkehr zwischen zwei VMs wiederholen |
| 04 | `dns.query`, `tls.sni`, `tls.cert_subject`, `http.method`, `http.host`, `pcre` | L; `tls.cert_subject` traf bei TLS 1.3 nicht | mit TLS 1.2 vergleichen |
| 05 | `threshold` in der Regel, `suppress` in `threshold.config`, `pass`-Regel, Regel auskommentieren | L | auf `ids01` wiederholen; Wirkung der `pass`-Regel mit Dokumentation belegen |
| 06 | `drop`, `reject`, `[wDrop]`; NFQ-Beschreibung in `ips_nfqueue.txt` | Offline: L; Inline (NFQ): nicht ausgeführt | Inline-Betrieb auf `ids01` testen |
| 07 | `rule-files`, doppelte SIDs, `rev`; `suricata-update` und `disable.conf` in `regelquellen.txt` | L; `suricata-update`: nicht ausgeführt | mit Internetzugang ausprobieren |
| 08 | `stats.log`, Bericht aus `eve.json`, Abschlussprojekt | L | auf `ids01` mit echtem Verkehr wiederholen |
