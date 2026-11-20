# Anmerkungen zum Lehrplan P13

Beim Ausarbeiten und Testen aufgefallene Punkte. Der Lehrplan selbst wurde zusammen mit der Übungsreihe erstellt und danach **nicht** verändert.

| Nr. | Modul | Befund | Vorschlag |
|---|---|---|---|
| 1 | alle | **Laborbeschreibung:** Der Prompt nennt „1x Windows-Server-VM; 1x Windows-11-Client-VM“; für ein Tier-Modell, LAPS und Gruppenrichtlinien braucht es eine Domäne. `srv01` übernimmt daher im Labor beide Rollen (Domänencontroller und Dateiserver), was im Betrieb nicht zu empfehlen ist. | Im Lehrplan so beschrieben; ggf. eine zweite Server-VM ergänzen. |
| 2 | alle | **Skripte:** Es lief kein Windows. Die Skripte sind Python-Prüfwerkzeuge für Exportdateien mit erfundenen Daten und ersetzen keine Prüfung in der VM. | In Hyper-V mit echten Exporten wiederholen. |
| 3 | 02 | **Prüfpunkte:** Das Zurücksetzen eines Domänencontrollers auf einen Prüfpunkt kann Active Directory schädigen; die Laborbeschreibung warnt davor. | Sicherung des Systemzustands für `srv01` einplanen. |
| 4 | 07 | **LAPS und Prüfpunkte:** Rollback-Erkennung gilt laut Dokumentation erst ab Windows Server 2025 / Windows 11 24H2 und braucht das Schema des Windows-Server-2025-Waldes. | Serverversion im Labor entsprechend wählen oder Hinweis beachten. |
| 5 | 12 | **Priorität:** Modul 12 ist Priorität 2; kein anderes Modul setzt es voraus. | Keine Änderung nötig. |
| 6 | 06 | **Defender, Firewall, Patchverfahren:** Dokumentation nicht gelesen, Aussagen Fachwissen. | Vor dem Einsatz mit den Microsoft-Seiten abgleichen. |
