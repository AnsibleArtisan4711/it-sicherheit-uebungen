# Anmerkungen zum Lehrplan P14

Beim Ausarbeiten und Testen aufgefallene Punkte. Der Lehrplan selbst wurde zusammen mit der Übungsreihe erstellt und danach **nicht** verändert.

| Nr. | Modul | Befund | Vorschlag |
|---|---|---|---|
| 1 | alle | **Laborbeschreibung:** Der Prompt nennt „1x Linux-Server-VM (frisch installiert)“; die Aufgaben der Module 5 und 9 brauchen einen zweiten Rechner (`cl01`), um Anmeldungen und Firewall-Regeln von außen zu prüfen. | Im Lehrplan `cl01` als erforderlich nennen (ist im Lehrplan dieser Reihe geschehen). |
| 2 | 02 | **Hash-Verfahren:** `ENCRYPT_METHOD SHA512` in `login.defs` ist unter Ubuntu 24.04 nicht maßgeblich; neue Passwörter wurden mit yescrypt gespeichert (PAM-Konfiguration). | Hinweis in Einheit 2.1 ergänzen. |
| 3 | 06 | **systemd:** Die Aufgaben zu `systemctl` konnten im Container nicht geprüft werden. | Erstdurchlauf in der VM. |
| 4 | 08 | **AppArmor/SELinux:** Im Test-Kernel nicht aktiv; Durchsetzung nicht prüfbar. | In der VM ausführen; Aufgabe 2 mit `aa-status` ergänzen. |
| 5 | 12 | **Priorität:** Modul 12 ist Priorität 2; Modul 13 nutzt es nicht. | Keine Änderung nötig. |
| 6 | 13 | **Lynis:** Die SSH-Tests werden übersprungen, wenn kein sshd-Prozess läuft; der Index ändert sich dann durch SSH-Maßnahmen nicht. | Hinweis „sshd muss laufen“ in Einheit 13.1 ergänzen. |
