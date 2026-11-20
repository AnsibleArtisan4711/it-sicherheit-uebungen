# Anmerkungen zum Lehrplan P15

Beim Ausarbeiten und Testen aufgefallene Punkte. Der Lehrplan selbst wurde zusammen mit der Übungsreihe erstellt und danach **nicht** verändert.

| Nr. | Modul | Befund | Vorschlag |
|---|---|---|---|
| 1 | alle | **Laborbeschreibung:** Der Prompt nennt „1x Scanner-VM; 1x Windows-Ziel-VM; 1x Linux-Ziel-VM“; für die Skripte der Übung dient ein Container mit zwei Namespaces als Ersatz. | Im Lehrplan ist die Hyper-V-Variante beschrieben; Skripte in Hyper-V erstmals ausführen. |
| 2 | 06 | **Scanner:** Greenbone und Nessus wurden nicht ausgeführt; Angaben stammen aus der Dokumentation (Stand 20.11.2026) und können sich ändern. | Einrichtung auf `scan01` durchspielen; Versionen und Dauer eintragen. |
| 3 | 05 | **CVSS:** Die Formeln stammen aus Fachwissen; die Spezifikation war nicht abrufbar. | Werte gegen den FIRST-Rechner prüfen. |
| 4 | 07 | **Beispieldaten:** Die Hinweise in `beispiel_hinweise.csv` sind erfunden. | Durch echte Herstellerhinweise ersetzen, wenn mit echten Systemen geübt wird. |
| 5 | 12 | **Priorität:** Modul 12 ist Priorität 2; kein anderes Modul setzt es voraus. | Keine Änderung nötig. |
| 6 | 03 | **Version-all:** `--version-all` hängt im Testrechner mehrere Minuten; die Skripte verwenden `--version-light`. | Im Unterricht Dauer beobachten. |
