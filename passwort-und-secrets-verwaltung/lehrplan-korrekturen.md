# Anmerkungen zum Lehrplan P63

Beim Ausarbeiten und Testen aufgefallene Punkte. Der Lehrplan selbst wurde zusammen mit der Übungsreihe erstellt und danach **nicht** verändert.

| Nr. | Modul | Befund | Vorschlag |
|---|---|---|---|
| 1 | alle | **Ausführung:** Alle Skripte liefen im Cloud-Container (Ubuntu 24.04, kein systemd). Das Verhalten auf `sec01` und mit anderen Versionen wurde nicht getestet. Alle Geheimnisse sind erfunden. | Übungen auf `sec01` nachvollziehen; Ausgaben vergleichen. |
| 2 | alle | **Nicht ausgeführt:** OpenBao, HashiCorp Vault, Passwortmanager-Programme, Mehr-Faktor-Verfahren. `beispiel_cli.txt` ist Text aus Fachwissen und **nicht bestätigt**. | Im Labor ausführen und Ergebnis eintragen. |
| 3 | alle | **Quellen:** Empfehlungen zu Passwortrichtlinien und die Dokumentation von `age`, `gpg`, OpenBao und Vault wurden nicht gelesen; Lizenzmodelle nicht recherchiert. | Quellen lesen und eintragen. |
| 4 | 02 | **Zeiten:** Die Messwerte schwanken von Lauf zu Lauf; die Musterlösung nennt gerundete Größenordnungen. | Beim Vergleich Toleranz einplanen. |
| 5 | 05 | **Scanner:** Der Scanner ist ein einfaches Lernmodell; Lücken (Schritt 1) sind gewollt. Echte Scanner wurden nicht geprüft. | Mit einem geprüften Werkzeug vergleichen. |
| 6 | 06 | **root:** Das Skript lief als `root`; die Sicht anderer Benutzer auf Prozessargumente ist Fachwissen und wurde nicht geprüft. | Als normaler Benutzer mit zweiter Sitzung prüfen. |
| 7 | 08 | **Priorität:** Modul 8 ist Priorität 2; kein anderes Modul setzt es voraus. Das Modell enthält keine Verschlüsselung. | Bei Zeitmangel entfallen lassen. |
