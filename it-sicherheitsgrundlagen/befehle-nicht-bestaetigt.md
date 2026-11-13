# Befehle und Aussagen, die nicht bestätigt sind

Prüfliste für den ersten Durchlauf in den Hyper-V-VMs: Befund und Datum eintragen, danach den Hinweis in der Übung entfernen. Legende: **Q** = gegen Quelle gelesen; **L** = in der Testumgebung (Namespaces) ausgeführt; **–** = weder noch.

| Modul | Befehl oder Aussage | Status | Nächster Schritt |
|---|---|---|---|
| alle | Alle Windows-Befehle (PowerShell, `icacls`, `net use`, `gpedit.msc`, Ereignisanzeige, RDP) | – (Parameter einiger Cmdlets Q) | in den VMs ausführen und Befund eintragen |
| alle | Aufbau des Hyper-V-Labors, `Copy-VMFile`, Gastdienst, „Default Switch“ | – | Vorbereitung laut Lehrplan prüfen |
| 01, 02, 09, 11 | Aussagen zu Schutzzielen, Angriffsarten, ISO/IEC 27001, BSI, DSGVO, Incident Response, BCP/DRP (Fachwissen) | – | gegen Quellen prüfen |
| 03 | `Get-FileHash` (Standard SHA256) | Q (Microsoft Learn), nicht ausgeführt | auf Windows ausführen |
| 03 | Hash-Unterschied durch UTF-16 und CRLF in Windows PowerShell 5.1 | – | nachprüfen |
| 03 | `sha256sum`, `openssl genrsa/rsa`, Signatur, RSA-OAEP, AES, selbstsigniertes Zertifikat | L (OpenSSL 3.0.13) | auf Ubuntu 24.04 und Debian wiederholen |
| 04 | `New-LocalUser`, `New-LocalGroup`, `Add-LocalGroupMember`, `New-SmbShare`, `net use` | – | ausführen, Parameter prüfen |
| 04 | `icacls` mit `/inheritance:r` (Learn nennt `/inheritancelevel`), Rechtekürzel und Vererbung | Q (teilweise), nicht ausgeführt | `icacls /?` auf der VM lesen |
| 04 | POSIX: `groupadd`, `useradd`, `chmod 750`, `ls -lR`, `find -printf`, `diff` | L | auf Ubuntu mit `sudo` wiederholen |
| 05 | Regeln mit `New-NetFirewallRule`, `Disable-NetFirewallRule -DisplayGroup`, `Test-NetConnection`; Vorrang von Block vor Allow | Q (Parameter), nicht ausgeführt | ausführen; Gruppennamen prüfen |
| 05 | UFW: Regeln, `default deny`, `enable`, `status verbose`; Nmap-Wirkung | L (ufw 0.36.2) | auf Ubuntu 24.04 wiederholen |
| 06 | Gruppenrichtlinien (Pfade), `Set-Service`, `Get-HotFix`, `services.msc` | – | ausführen |
| 06 | `passwd -S root`, `uname -r`, `lsb_release -a`, `/etc/fstab`, `systemctl disable` | L (nur die ersten drei; im Container) | auf der VM ausführen |
| 07 | SSH: Schlüssel, `sshd -t`, Härtung, `sshd -T` | L (Port 2222, ohne PAM) | auf Ubuntu 24.04 mit PAM und `sshd_config.d` wiederholen |
| 07 | Schlüsselübertragung per PowerShell-Pipe, `systemctl reload ssh` | – | prüfen |
| 07 | RDP: NLA-Registrywert, Gruppe „Remotedesktopbenutzer“, Meldungstext | – | ausführen |
| 07 | TLS: `openssl s_server`/`s_client`, `curl` mit selbstsigniertem Zertifikat | L | wiederholen |
| 08 | `cvss31.py` (Formeln aus dem Gedächtnis), `ale.py` | L (Selbsttest mit 7 Werten) | gegen FIRST.Org-Spezifikation und -Rechner prüfen |
| 10 | Audit-Richtlinie (`auditpol`), Ereignis-ID 4624/4625, `Get-WinEvent` | Q (IDs), nicht ausgeführt | ausführen |
| 10 | `auth.log`/`syslog`, `su`-Fehler, Wireshark; Debian 12 mit Journal | – | auf der VM prüfen |
| 10 | `tcpdump` statt Wireshark, `http.server` statt Apache | L | mit Wireshark und Apache wiederholen |
| 11 | `Disconnect-VMNetworkAdapter` und Ablauf der Tabletop-Übung | – | prüfen |
| 12 | Nmap gegen den Windows-Server (hier nftables-Nachbildung), `Compare-Object`, `Set-NetFirewallRule` | L (nur Nachbildung) | gegen echten Windows-Server wiederholen |
| 12 | Standard-Verhalten der Windows-Firewall bei Ping | – | prüfen |
