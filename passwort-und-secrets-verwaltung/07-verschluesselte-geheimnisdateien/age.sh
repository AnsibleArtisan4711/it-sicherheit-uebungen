#!/usr/bin/env bash
# Modul 7: Verschlüsselte Geheimnisdateien mit age: mehrere Empfänger, Entzug eines Empfängers, Schlüsselwechsel. Erfundene Werte.
. "$(dirname "$0")/../lab.sh"
lab_up
age --version | head -1
step "1. Schlüsselpaare für zwei Personen erzeugen (anna, ben)"
age-keygen -o "$W/anna.key" >/dev/null 2>&1; age-keygen -o "$W/ben.key" >/dev/null 2>&1
AP=$(age-keygen -y "$W/anna.key"); BP=$(age-keygen -y "$W/ben.key")
echo "öffentlicher Schlüssel (anna): ${AP:0:8}…  Länge ${#AP}"; echo "Rechte der privaten Datei: $(stat -c %a "$W/anna.key")"
step "2. Datei für beide Empfänger verschlüsseln"
echo "db_password=Beispiel-Geheim-9" > "$W/secret.env"
age -r "$AP" -r "$BP" -o "$W/secret.env.age" "$W/secret.env"
echo "Chiffrat enthält Klartext? $(grep -c Beispiel "$W/secret.env.age")"; head -c 22 "$W/secret.env.age"; echo
step "3. Beide können entschlüsseln"
echo "anna: $(age -d -i "$W/anna.key" "$W/secret.env.age")"; echo "ben:  $(age -d -i "$W/ben.key" "$W/secret.env.age")"
step "4. Dritte Person (cara, nicht Empfänger) scheitert"
age-keygen -o "$W/cara.key" >/dev/null 2>&1
age -d -i "$W/cara.key" "$W/secret.env.age" 2>&1 | head -2
step "5. Empfänger entziehen: neu verschlüsseln nur für anna. Die alte Datei bleibt für ben lesbar."
age -r "$AP" -o "$W/secret2.age" "$W/secret.env"
echo "ben mit neuer Datei: $(age -d -i "$W/ben.key" "$W/secret2.age" 2>&1 | head -1)"
echo "ben mit alter Datei: $(age -d -i "$W/ben.key" "$W/secret.env.age" 2>&1 | head -1)"
echo "Folge: Wurde das Geheimnis einmal gelesen, hilft nur, das Geheimnis selbst zu ersetzen (Rotation)."
step "6. Hinweis"
echo "Der Passphrase-Modus von age fragt am Terminal und wurde nicht ausgeführt."
lab_down
