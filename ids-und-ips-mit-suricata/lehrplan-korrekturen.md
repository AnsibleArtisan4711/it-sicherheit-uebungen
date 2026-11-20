# Anmerkungen zum Lehrplan P62

Beim Ausarbeiten und Testen aufgefallene Punkte. Der Lehrplan selbst wurde zusammen mit der Übungsreihe erstellt und danach **nicht** verändert.

| Nr. | Modul | Befund | Vorschlag |
|---|---|---|---|
| 1 | alle | **Ausführung:** Alle Skripte liefen im Cloud-Container (Ubuntu 24.04, kein systemd) mit Suricata 7.0.3 im Offline-Modus auf Loopback-Mitschnitten. Das Verhalten in echten Netzen, mit anderen Versionen und im Inline-Betrieb wurde nicht getestet. | Übungen auf `ids01` nachvollziehen; Ausgaben vergleichen. |
| 2 | alle | **Nicht ausführbar im Container:** Inline-Betrieb (NFQ), `suricata-update` und Regelquellen, Betrieb als Dienst, Leistungsmessung. Diese Teile sind Textdateien aus Fachwissen und **nicht bestätigt**. | Auf `ids01` ausführen und Ergebnis eintragen. |
| 3 | alle | **Quellen:** Die Dokumentation von Suricata wurde nicht gelesen. | Quellen lesen und eintragen. |
| 4 | 03 | **Paketzahlen:** Die Zahl der Pakete schwankt von Lauf zu Lauf um ein bis zwei Pakete (Zeitverhalten der Verbindungen); die Musterlösung nennt gerundete Werte. | Beim Vergleich Toleranz einplanen. |
| 5 | 04 | **TLS 1.3:** `tls.cert_subject` traf nicht, weil das Zertifikat bei TLS 1.3 verschlüsselt übertragen wird; ob eine Erzwingung von TLS 1.2 mit `openssl s_client -tls1_2` die Regel auslöst, wurde nicht geprüft. | Im Labor mit TLS 1.2 prüfen. |
| 6 | 05 | **`pass`-Regel:** Die Wirkung (HTTP-Meldungen verschwinden, Meldungen auf den Verbindungsaufbau bleiben) ist eine Beobachtung dieses Laufs; die Auswertungsreihenfolge wurde nicht gegen die Dokumentation geprüft. | Mit der Dokumentation der Version belegen. |
| 7 | 06 | **Priorität:** Modul 6 ist Priorität 2; kein anderes Modul setzt es voraus. In `eve.json` zeigte der Lauf für `alert` und `drop` die Aktion „allowed“, für `reject` „blocked“; die Ursache wurde nicht untersucht. | Bei Zeitmangel entfallen lassen; Verhalten prüfen. |
| 8 | 07 | **Standardpfad:** `default-rule-path` verweist auf `/var/lib/suricata/rules`; die dort erwartete Datei `suricata.rules` entsteht erst durch `suricata-update` und war im Container nicht vorhanden. | Auf `ids01` nach der Installation prüfen. |
