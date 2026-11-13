# Szenario: Krankenhaus `med.example.com` (frei erfunden)

Das Klinikum Beispielstadt (Domäne `med.example.com`, nach RFC 2606 reserviert) betreibt drei IT-Systeme, die du bewerten sollst. Alle Angaben sind erfunden.

| System | Beschreibung |
|---|---|
| **Patientenakte** | Elektronische Akte mit Diagnosen, Medikation, Befunden und Laborwerten; wird auf allen Stationen rund um die Uhr benutzt, auch zur Notaufnahme. |
| **Öffentlicher Webserver** | Informationsseite des Klinikums mit Besuchszeiten, Fachabteilungen und Kontakt. Redakteure pflegen die Inhalte; keine personenbezogenen Patientendaten. |
| **Backup-Archiv** | Nächtliche Sicherungen der Patientenakte und anderer Systeme auf Band und in einem Schrank im Nebengebäude; wird nur bei Datenverlust benutzt. |

**Aufgabe:** Bewerte für jedes System, wie wichtig Vertraulichkeit, Integrität und Verfügbarkeit sind (hoch, mittel, niedrig) und begründe jede Einstufung in einem Satz.
