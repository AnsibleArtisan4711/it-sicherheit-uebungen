# Befehle und Aussagen, die nicht bestätigt sind

Prüfliste für den ersten Durchlauf in den Hyper-V-VMs: Befund und Datum eintragen, danach den Hinweis in der Übung entfernen. Legende: **Q** = gegen Quelle gelesen; **L** = im Labor (Container) ausgeführt; **–** = weder noch.

| Modul | Befehl oder Aussage | Status | Nächster Schritt |
|---|---|---|---|
| alle | Aufbau des Hyper-V-Labors (privater Switch, `vm01`, `cl01`), Internetphase für die Pakete | – | laut Lehrplan aufbauen und prüfen |
| alle | Verhalten auf Debian 12 (Paketversionen von OpenSSH 9.2, sudo 1.9.13, AIDE, fail2ban) statt Ubuntu 24.04 | – | in der Debian-VM wiederholen |
| 01 | `lynis audit system --quick`, Kennzahlen aus `/var/log/lynis-report.dat` | L (Lynis 3.0.9) | in der frisch installierten VM wiederholen; Index notieren |
| 01 | Aussagen zu CIS Benchmarks (Profilstufen, Verfügbarkeit nach Registrierung) | – (Fachwissen) | gegen die Quelle prüfen |
| 02 | `useradd`, `usermod -L`, `chage`, `passwd -S`, UID-0- und Leere-Passwort-Suche | L | in der VM wiederholen |
| 02 | Hash-Verfahren yescrypt (`$y$`) bei Ubuntu 24.04; Verhalten bei Debian 12 | L (Ubuntu); Debian – | Debian prüfen (`/etc/pam.d/common-password`) |
| 03 | `pwscore`, `pwmake`, `pam_faillock` mit `pamtester`, `faillock --reset` | L | in der VM wiederholen; `common-auth` testen |
| 04 | `visudo -cf`, `sudo -l -U`, Regeln in `sudoers.d`, Protokolldatei | L (sudo 1.9.15p5) | in der VM wiederholen; Aussage zu `NOEXEC` prüfen |
| 05 | `sshd -t`, `sshd -T`, Schlüsselanmeldung, `AllowGroups`, Weiterleitung, `ssh-audit` | L (OpenSSH 9.6p1, ssh-audit 3.9.0) | auf Debian 12 (OpenSSH 9.2) wiederholen; Algorithmenlisten anpassen |
| 05 | Zwei-Faktor-Anmeldung (TOTP mit PAM), `Match`-Blöcke | – (Fachwissen) | ausprobieren oder streichen |
| 06 | `systemctl disable/mask`, `systemctl list-unit-files`, `systemd-analyze security` | – (Container ohne systemd) | in der VM ausführen |
| 06 | `ss`, `sysctl` im Namespace, Soll-Ist-Vergleich der Parameter | L | in der VM wiederholen (`sysctl --system`) |
| 07 | `setfacl`, `getfacl`, `chattr`, Mount-Optionen `noexec`/`nosuid`/`nodev`, SUID-Suche | L | in der VM wiederholen; `/etc/fstab`-Änderung testen |
| 08 | AppArmor: Profil laden, Modi complain/enforce, `aa-status`, `aa-genprof`; SELinux-Befehle | – (nur Syntax mit `apparmor_parser -Q -K` geprüft: L) | in der VM mit AppArmor-Kernel prüfen |
| 09 | `nft`-Regelwerk des Servers, Rate-Limit, Zähler | L (nftables 1.0.9) | in der VM (Debian 12: nftables 1.0.6) wiederholen |
| 09 | `ufw`-Befehle und `ufw --dry-run` | – (Fachwissen) | in der VM ausführen |
| 10 | `auditd`, `auditctl -R`, `ausearch`, `aureport`; `augenrules` | L (auditd 3.1.2, ohne systemd); `augenrules` – | in der VM mit systemd wiederholen |
| 10 | `journalctl`, `logrotate`, Weiterleitung mit rsyslog, Zeitsynchronisation | – (Fachwissen) | in der VM prüfen |
| 11 | `unattended-upgrade --dry-run`, `apt-config dump`, `needrestart -b` | L (Ubuntu 24.04, Python 3.12 für apt_pkg) | in der VM wiederholen; Debian-Herkünfte prüfen |
| 12 | `aide --init/--check` mit eigener Konfiguration; `fail2ban-regex` | L (AIDE 0.18.6, fail2ban 1.0.2) | Jail in der VM starten und Sperre testen |
| 13 | `pruefkatalog.sh`, `haertung_anwenden.sh`, Messung Lynis vorher/nachher | L | in der VM wiederholen |
| 13 | Fehlersuche (fünf eingebaute Fehler) | – (Fachwissen) | in der VM durchspielen |
