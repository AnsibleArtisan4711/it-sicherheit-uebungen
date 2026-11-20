#!/usr/bin/env bash
# Modul 2: Passwort-Hashing (Salz, PBKDF2, scrypt, bcrypt, Zeitmessung, Vergleich mit einfachem SHA-256).
. "$(dirname "$0")/../lab.sh"
step "1. Gleiches Passwort, einfacher Hash: SHA-256 ohne Salz (zweimal derselbe Wert)"
python3 - <<'PY'
import hashlib
for _ in range(2): print(hashlib.sha256(b"Sommer2026!").hexdigest())
PY
step "2. Mit Salz: PBKDF2-HMAC-SHA256, zwei Salze, gleiche Passwörter, verschiedene Werte"
python3 - <<'PY'
import hashlib, os
for s in (bytes.fromhex("00112233445566778899aabbccddeeff"), bytes.fromhex("ffeeddccbbaa99887766554433221100")):
    print(s.hex()[:8], hashlib.pbkdf2_hmac("sha256", b"Sommer2026!", s, 100000).hex()[:32])
PY
step "3. Kosten: Zeit je Hash (Mittelwert aus 5 Läufen, Millisekunden, Rechner des Tests)"
python3 - <<'PY'
import hashlib, time, bcrypt
def t(f, n=5):
    a = time.perf_counter()
    for _ in range(n): f()
    return (time.perf_counter() - a) / n * 1000
salt = bytes(16)
r = [("SHA-256 (einfach)", t(lambda: hashlib.sha256(b"x").digest(), 1000)),
     ("PBKDF2 100000 Runden", t(lambda: hashlib.pbkdf2_hmac("sha256", b"x", salt, 100000))),
     ("PBKDF2 600000 Runden", t(lambda: hashlib.pbkdf2_hmac("sha256", b"x", salt, 600000))),
     ("scrypt n=2^14,r=8,p=1", t(lambda: hashlib.scrypt(b"x", salt=salt, n=2**14, r=8, p=1))),
     ("bcrypt Kosten 10", t(lambda: bcrypt.hashpw(b"x", bcrypt.gensalt(10)))),
     ("bcrypt Kosten 12", t(lambda: bcrypt.hashpw(b"x", bcrypt.gensalt(12))))]
base = r[0][1]
for n, ms in r: print("%-24s %10.4f ms  (%s× SHA-256)" % (n, ms, "{:,.0f}".format(ms / base).replace(",", ".")))
PY
step "4. bcrypt: Prüfen, Format und Kostenfaktor"
python3 - <<'PY'
import bcrypt
h = bcrypt.hashpw(b"Sommer2026!", bcrypt.gensalt(10))
print("Länge:", len(h), " Anfang:", h[:7].decode(), " (2b = Verfahren, 10 = Kosten)")
print("richtig:", bcrypt.checkpw(b"Sommer2026!", h), " falsch:", bcrypt.checkpw(b"Sommer2027!", h))
print("zwei Hashes desselben Passworts gleich?", bcrypt.hashpw(b"x", bcrypt.gensalt(4)) == bcrypt.hashpw(b"x", bcrypt.gensalt(4)))
PY
step '5. openssl passwd: SHA-512-Crypt (Format $6$)'
openssl passwd -6 -salt abcdefgh 'Sommer2026!' | sed -E 's/^(\$6\$abcdefgh\$).*/\1…/'
echo "Zweimal gleich: $([ "$(openssl passwd -6 -salt abcdefgh x)" = "$(openssl passwd -6 -salt abcdefgh x)" ] && echo ja || echo nein)"
