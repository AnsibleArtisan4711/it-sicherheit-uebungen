#!/usr/bin/env bash
# Modul 4: Prinzip eines Passwortmanagers: verschlüsselter Tresor (scrypt + Fernet), Fehlversuch, Änderung; gpg symmetrisch zum Vergleich.
. "$(dirname "$0")/../lab.sh"
lab_up
export GNUPGHOME="$W/gnupg"; mkdir -m 700 "$W/gnupg"
cat > "$W/tresor.py" <<'PY'
import base64, json, os, sys
from cryptography.fernet import Fernet, InvalidToken
from cryptography.hazmat.primitives.kdf.scrypt import Scrypt
def schluessel(pw, salt):
    return base64.urlsafe_b64encode(Scrypt(salt=salt, length=32, n=2**14, r=8, p=1).derive(pw.encode()))
def speichern(pfad, pw, daten):
    salt = os.urandom(16)
    open(pfad, "wb").write(salt + Fernet(schluessel(pw, salt)).encrypt(json.dumps(daten).encode()))
def laden(pfad, pw):
    b = open(pfad, "rb").read(); salt, tok = b[:16], b[16:]
    return json.loads(Fernet(schluessel(pw, salt)).decrypt(tok))
PY
step "1. Tresor anlegen (erfundene Zugangsdaten) und lesen"
python3 - "$W" <<'PY'
import sys; sys.path.insert(0, sys.argv[1]); import tresor
p = sys.argv[1] + "/tresor.bin"
tresor.speichern(p, "Meister-Passphrase-Beispiel", {"wiki": {"user": "anna", "pw": "Beispiel-1"}, "router": {"user": "admin", "pw": "Beispiel-2"}})
print("Dateigröße:", len(open(p, "rb").read()), "Bytes; Klartext 'Beispiel' in der Datei?", b"Beispiel" in open(p, "rb").read())
print("Einträge:", sorted(tresor.laden(p, "Meister-Passphrase-Beispiel")))
PY
step "2. Falsche Passphrase"
python3 - "$W" <<'PY'
import sys; sys.path.insert(0, sys.argv[1]); import tresor
from cryptography.fernet import InvalidToken
try: tresor.laden(sys.argv[1] + "/tresor.bin", "falsch")
except InvalidToken: print("InvalidToken: Entschlüsselung fehlgeschlagen, kein Teil der Daten lesbar")
PY
step "3. Veränderung der Datei wird erkannt (ein Byte geändert)"
python3 - "$W" <<'PY'
import sys; sys.path.insert(0, sys.argv[1]); import tresor
from cryptography.fernet import InvalidToken
p = sys.argv[1] + "/tresor.bin"; b = bytearray(open(p, "rb").read()); b[-5] ^= 1; open(p + ".bad", "wb").write(b)
try: tresor.laden(p + ".bad", "Meister-Passphrase-Beispiel")
except InvalidToken: print("InvalidToken: Manipulation erkannt")
PY
step "4. Zwei Tresore mit gleichem Inhalt und gleicher Passphrase sind verschieden (Salz und Nonce)"
python3 - "$W" <<'PY'
import sys; sys.path.insert(0, sys.argv[1]); import tresor
d = {"a": "b"}; tresor.speichern(sys.argv[1] + "/t1", "x", d); tresor.speichern(sys.argv[1] + "/t2", "x", d)
print("Dateien gleich?", open(sys.argv[1] + "/t1", "rb").read() == open(sys.argv[1] + "/t2", "rb").read())
PY
step "5. Zum Vergleich: gpg symmetrisch (AES-256), Passphrase über Datei"
echo "router-pw=Beispiel-2" > "$W/geheim.txt"; echo -n "Meister-Passphrase-Beispiel" > "$W/pp"
gpg --batch --yes --pinentry-mode loopback --passphrase-file "$W/pp" --symmetric --cipher-algo AES256 -o "$W/geheim.gpg" "$W/geheim.txt" 2>&1 | grep -v "^gpg: WARNING" | head -2
echo "Chiffrat enthält Klartext 'Beispiel'? $(grep -c Beispiel "$W/geheim.gpg")"
gpg --batch --quiet --pinentry-mode loopback --passphrase-file "$W/pp" -d "$W/geheim.gpg" 2>/dev/null
echo -n "falsch" > "$W/pp2"; gpg --batch --quiet --pinentry-mode loopback --passphrase-file "$W/pp2" -d "$W/geheim.gpg" 2>&1 | grep -iE "decryption failed|bad" | head -1
lab_down
