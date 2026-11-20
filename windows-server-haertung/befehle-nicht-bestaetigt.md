# Befehle und Aussagen, die nicht bestätigt sind

Prüfliste für den ersten Durchlauf in den Hyper-V-VMs: Befund und Datum eintragen, danach den Hinweis in der Übung entfernen. Legende: **Q** = gegen Quelle gelesen; **L** = im Labor (Container) ausgeführt; **–** = weder noch.

| Modul | Befehl oder Aussage | Status | Nächster Schritt |
|---|---|---|---|
| alle | Aufbau des Hyper-V-Labors (privater Switch `Lab-WinHaertung`, `srv01` als Domänencontroller und Dateiserver, `cl01` als Windows 11) | – | laut Lehrplan aufbauen und prüfen |
| alle | Alle PowerShell- und Windows-Befehle im Text (`gpresult`, `gpupdate`, `auditpol` außer Syntax aus der Dokumentation, `Test-NetConnection`, gMSA-Cmdlets) | – (nicht ausgeführt) | in der VM ausführen und Ausgaben eintragen |
| 01 | Vergleich einer Sicherheitsvorlage (INF, vereinfacht nachgebaut) mit einer Baseline-Tabelle (`baseline_vergleich.py`) | L (Python 3, erfundene Daten) | mit echtem `secedit`-Export und dem Policy Analyzer prüfen |
| 01 | Microsoft Security Compliance Toolkit: Baselines für Windows Server 2016 bis 2025, Policy Analyzer, LGPO, Formate `.pol`/`.inf`/`.csv` | – (Dokumentationsauszug gelesen) | Toolkit herunterladen und ausprobieren |
| 01 | CIS Benchmarks (Profilstufen, Verfügbarkeit nach Registrierung) | – (Fachwissen) | gegen die Quelle prüfen; Inhalte nicht übernehmen |
| 02 | Tier-Modell (Tier 0/1/2, PAW, „saubere Tastatur“), Enterprise Access Model | – (Dokumentationsauszug gelesen) | vollständige Seiten lesen; Anmelde-Regeln per GPO in der VM testen |
| 03 | Gruppenrichtlinien-Vorrang als Modell (`gpo_vorrang.py`); `gpresult`, `gpupdate` | L (Modell); Befehle – | in der Domäne mit echten GPOs prüfen |
| 04 | Kennwort-, Sperrrichtlinien, PSO, gMSA; Konten-Export (`konten_pruefen.py`) | L (erfundene Daten); Rest – | in der Domäne prüfen; aktuelle Empfehlungen nachlesen |
| 05 | Dienste und Rollen (Positivliste, Server Core) | L (erfundene Daten); Wirkungen – | in der VM prüfen, Abhängigkeiten ansehen |
| 06 | Microsoft Defender Antivirus und Windows-Firewall (Profile, Regeln, Ausschlüsse) | – (Fachwissen) | Dokumentation lesen und in der VM ausführen |
| 07 | Windows LAPS: Cmdlet-Namen, Verschlüsselung (Domänenfunktionsebene 2016), Rollback-Erkennung ab Server 2025 | – (Dokumentationsauszug gelesen, nicht ausgeführt) | in der Testdomäne einrichten und prüfen |
| 07 | Attributname `msLAPS-PasswordExpirationTime` und FILETIME-Umrechnung (`laps_pruefen.py`) | L (Umrechnung); Attributname – (Fachwissen) | in AD prüfen |
| 08 | `auditpol /get /category:*` und `/set` (Syntax aus Dokumentation), CSV-Format von `auditpol ... /r` | Syntax: Dokumentation; CSV-Format – | in der VM ausführen und Format vergleichen |
| 09 | Ereignis-Kennungen 4624, 4625, 4720, 4688 (Dokumentation); 4732 und 1102 | Dokumentation bzw. – | 4732 und 1102 gegen Microsoft-Dokumentation prüfen |
| 10 | Patch-Management (WSUS, Windows Update for Business, Ringe) | – (Fachwissen) | Dokumentation lesen; in der VM prüfen |
| 11 | RDP/NLA, SMB1, SMB-Signierung, NTLM-Stufen, WinRM über HTTPS | – (Fachwissen); Skript L (erfundene Daten) | in der VM prüfen |
| 12 | Credential Guard: Standardaktivierung ab Windows 11 22H2 / Server 2025, Einschränkungen; Anwendungskontrolle, Secure Boot, BitLocker | Credential Guard: Dokumentationsauszug; Rest – | in der VM prüfen (VBS, vTPM) |
| 13 | `haertung_bericht.py` (fasst Beispielprüfungen zusammen) | L | mit echten Exporten wiederholen |
