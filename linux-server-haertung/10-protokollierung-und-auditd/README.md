# 10 auditd

Übung **10.1** (Priorität 1). Geschätzte Zeit: 6 bis 8 Stunden (Schätzung; Lehrplan: 10 UE zu 45 Minuten = 7,5 Stunden).

> Skript im Container ausgeführt (auditd ohne systemd).

| Datei | Zweck |
|---|---|
| `10.1-protokollierung-und-auditd.md` | Die Übung mit Aufgaben, Kontrollfragen und Musterlösung |
| `audit.rules` | audit.rules – Beispielregeln für den Kurs (Ausschnitt, nicht vollständig) |
| `audit_test.sh` | Startet auditd, lädt Regeln (audit.rules), löst Ereignisse aus und wertet sie mit ausearch und aureport aus. |
| `beispiele/audit_test.ausgabe.txt` | Echte Ausgabe des Laufs von `audit_test` |
