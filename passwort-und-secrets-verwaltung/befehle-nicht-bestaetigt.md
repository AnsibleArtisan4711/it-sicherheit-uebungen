# Befehle und Aussagen, die nicht bestätigt sind

Prüfliste für den ersten Durchlauf in den Hyper-V-VMs: Befund und Datum eintragen, danach den Hinweis in der Übung entfernen. Legende: **Q** = gegen Quelle gelesen; **L** = im Labor (Container) ausgeführt; **–** = weder noch.

| Modul | Befehl oder Aussage | Status | Nächster Schritt |
|---|---|---|---|
| alle | Aufbau des Hyper-V-Labors (privater Switch `Lab-Secrets`, `sec01`), Installation der Pakete | – | laut Lehrplan aufbauen und prüfen |
| 01 | Entropie-Rechnung und Rate-Zeit-Modell in Python | L | auf `sec01` wiederholen |
| 02 | `hashlib.pbkdf2_hmac`, `hashlib.scrypt`, `bcrypt.hashpw`/`checkpw`, `openssl passwd -6` | L; Zeiten schwanken | auf `sec01` wiederholen; empfohlene Parameter mit aktuellen Quellen belegen |
| 03 | Richtlinienprüfer mit Sperrliste, `secrets.choice`, `random.seed` | L | auf `sec01` wiederholen |
| 04 | Tresor mit `scrypt` und `Fernet`; `gpg --symmetric --cipher-algo AES256` | L (eigenes `GNUPGHOME`) | auf `sec01` wiederholen |
| 05 | Eigener Scanner, `grep -rin`, `git log -p`, `.gitignore`, `pre-commit`-Hook | L | auf `sec01` wiederholen |
| 06 | `/proc/PID/cmdline`, `environ`, `umask`, `chmod`, Maskierung | L (als `root`) | als normaler Benutzer wiederholen |
| 07 | `age-keygen`, `age -r`, `age -d` | L (age 1.1.1) | auf `sec01` wiederholen; Passphrase-Modus nicht ausgeführt |
| 08 | Python-Modell eines Geheimnisdienstes; `beispiel_cli.txt` mit Befehlen von OpenBao/Vault | Modell: L; Befehle: nicht ausgeführt | Produkt im Labor testen; Lizenz und Version prüfen |
