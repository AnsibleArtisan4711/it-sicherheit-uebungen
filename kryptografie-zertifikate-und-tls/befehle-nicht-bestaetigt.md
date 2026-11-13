# Befehle und Aussagen, die nicht bestätigt sind

Prüfliste für den ersten Durchlauf in den Hyper-V-VMs: Befund und Datum eintragen, danach den Hinweis in der Übung entfernen. Legende: **Q** = gegen Quelle gelesen; **L** = in der Testumgebung (Namespaces) ausgeführt; **–** = weder noch.

| Modul | Befehl oder Aussage | Status | Nächster Schritt |
|---|---|---|---|
| alle | Alle Windows-Befehle und -Oberflächen (`certlm.msc`, `certutil`, `Import-Certificate`, BitLocker-Assistent, Datenträgerverwaltung, Edge, `curl.exe`) | – | in der VM `win11-01` ausführen und Befund eintragen |
| alle | Aufbau des Hyper-V-Labors, Hyper-V-Prüfpunkte, Zeitsynchronisierung, Vorbereitung mit Internet | – | laut Lehrplan prüfen |
| 01 | Inhalt der BSI TR-02102-1 (Schlüssellängen, zulässige Verfahren); nur Ausgabe „Version 2026-01 (23.01.2026)“ auf der BSI-Seite gelesen | Q (nur Titelangabe) | PDF lesen, Tabelle der Aufgabe 1 füllen |
| 01, 02, 03, 04, 05, 06 | Aussagen zu Schutzzielen, historischen Verfahren, AES/RSA/ECC-Vergleich, MD5/SHA-1 als veraltet, Nicht-Abstreitbarkeit (Fachwissen) | – | gegen Quellen (BSI, NIST, RFCs) prüfen |
| 02 | `openssl enc` (AES-CBC, ECB, GCM-Fehlermeldung, ChaCha20, `-pbkdf2`), Blockzählung mit `od` | L (OpenSSL 3.0.13) | auf Debian 12 und Ubuntu Server wiederholen |
| 03 | `genpkey`, `pkey`, `ecparam`, passwortgeschützte Kopie, X25519-`pkeyutl -derive`, RSA-OAEP | L | wiederholen |
| 04 | `sha256sum`, `openssl dgst`, HMAC | L | wiederholen |
| 05 | `dgst -sign/-verify`, Fremdsignatur | L | wiederholen |
| 06 | Root-Zertifikat aus `/etc/ssl/certs` (Dateiname `ISRG_Root_X1.pem` und Anzahl abhängig von `ca-certificates`), `-checkend`, `verify`, Erweiterungen CRL/AIA | L | auf der VM mit vorhandenem Zertifikat wiederholen |
| 07 | Lokale CA, CSR, `server.ext`, Zertifikat, `verify`; CRL mit `openssl ca` (Erweiterung) | L | wiederholen |
| 08 | `s_server -www`, `tshark` (Schnittstelle, Filter, `-V`), `curl -vk`, TLS 1.2/1.3-Vergleich, `openssl ciphers` | L (curl unter Linux, nicht `curl.exe`) | auf `linux01` und `win11-01` wiederholen; Schnittstellenname prüfen |
| 08 | Zertifikatswarnung im Browser (Edge) | – | auf `win11-01` prüfen |
| 09 | `s_client`, `verify -attime`, `-verify_hostname`, `-verify_ip` | L | wiederholen |
| 09 | `scp` von `linux01` nach Windows, `certutil -hashfile`, Import in „Vertrauenswürdige Stammzertifizierungsstellen“, `hosts`-Datei | – | in den VMs ausführen |
| 09 | Verhalten von `curl.exe` (Schannel) bei privater CA ohne CRL/OCSP, Meldungen von Edge bei Untrusted Root, Name Mismatch, Expired | – | auf `win11-01` prüfen; Fehlertexte in die Tabelle (Aufgabe 6) eintragen |
| 10 | `luksFormat`, `luksDump`, `luksAddKey`, `luksHeaderBackup/-Restore`, `luksKillSlot`, `open --test-passphrase` (Loop-Gerät, 64 MiB) | L (cryptsetup 2.7.0) | an einer echten zweiten Platte wiederholen |
| 10 | `luksOpen`, `mkfs.ext4`, `mount`, `umount`, `luksClose`, Lesbarkeit von `test.txt` nach `luksHeaderRestore` | – (kein Device-Mapper im Container) | in der VM ausführen |
| 11 | `manage-bde -lock`, `-unlock -recoverypassword`, `-protectors -get` | Q (Microsoft Learn), nicht ausgeführt | in `win11-01` ausführen |
| 11 | `manage-bde -status`, Assistent „BitLocker aktivieren“, Ausgabetexte, Edition-Voraussetzungen | – | ausführen; Texte der deutschen Oberfläche eintragen |
| 11 | Architektur (VMK/FVEK), Unterschied „Used Disk Space Only“, Rolle des TPM | – (Fachwissen) | gegen Microsoft Learn prüfen |
| 12 | `openssl passwd`, `openssl kdf PBKDF2`, `/etc/shadow` (Aufbau), `chpasswd` | L (Ubuntu 24.04) | auf Debian 12 wiederholen (andere Hash-Kennung möglich) |
