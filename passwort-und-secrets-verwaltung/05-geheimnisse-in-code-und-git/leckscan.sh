#!/usr/bin/env bash
# Modul 5: Geheimnisse in Dateien und Git: Suche mit eigenem Scanner, Verlauf bleibt erhalten, Umgang mit .gitignore. Alle Werte sind erfunden.
. "$(dirname "$0")/../lab.sh"
lab_up
R="$W/repo"; mkdir -p "$R"; cd "$R"
git init -q -b main; git config user.email "lab@example.invalid"; git config user.name "Lab"
echo 'DB_HOST=db01.example.invalid' > config.env
echo 'DB_PASSWORD=Beispiel-Geheim-1' >> config.env
printf 'import os\npassword = "Beispiel-Geheim-2"\napi_key = os.environ["API_KEY"]\n' > app.py
git add . && git commit -q -m "Erste Fassung"
step "1. Eigener Scanner (Muster: password/secret/token/api_key mit Zuweisung eines festen Wertes) und Vergleich mit grep"
cat > "$W/scan.py" <<'PY'
import re, sys, subprocess
muster = re.compile(r'(?i)\b(pass(word|wort)?|secret|token|api[_-]?key)\b\s*[:=]\s*["\']?([^\s"\'$][^\s"\']*)')
def zeilen(pfad):
    for n, z in enumerate(open(pfad, errors="replace"), 1):
        m = muster.search(z)
        if m and not m.group(3).startswith("os.environ"): yield n, z.strip()
dateien = subprocess.check_output(["git", "ls-files"], text=True).split()
treffer = 0
for d in dateien:
    for n, z in zeilen(d): treffer += 1; print(f"{d}:{n}: {z}")
print("Treffer:", treffer)
PY
python3 "$W/scan.py"
echo "Zum Vergleich, einfache Suche (grep -rin password, ohne .git):"; grep -rin password --exclude-dir=.git . | sed -E 's/^\.\///'
step "2. Falsche Lösung: Datei löschen und committen. Der Wert bleibt im Verlauf."
git rm -q config.env && git commit -q -m "Konfiguration entfernt"
echo "Datei im aktuellen Stand vorhanden? $([ -f config.env ] && echo ja || echo nein)"
echo "Wert im Verlauf auffindbar? $(git log -p --all | grep -c 'Beispiel-Geheim-1') Treffer in 'git log -p'"
step "3. Besser: Wert aus dem Code nehmen, Datei in .gitignore, Vorlage einchecken"
printf 'import os\npassword = os.environ["APP_PASSWORD"]\n' > app.py
echo 'config.env' > .gitignore
echo 'DB_PASSWORD=<hier-eintragen>' > config.env.beispiel
git add . && git commit -q -m "Geheimnisse aus dem Code, Vorlage statt Wert"
git ls-files | tr '\n' ' '; echo
echo -n "Scanner nach der Änderung: "; python3 "$W/scan.py" | tail -1
step "4. Was bleibt: der Wert steht weiterhin im Verlauf. Folge: Das Geheimnis ist als bekannt zu behandeln und zu ersetzen (Rotation)."
echo "Treffer im Verlauf: $(git log -p --all | grep -c 'Beispiel-Geheim-')"
step "5. Hook, der Commits mit Treffern verhindert (pre-commit, Nutzung des Scanners)"
cat > .git/hooks/pre-commit <<'H'
#!/usr/bin/env bash
git diff --cached --name-only --diff-filter=AM | while read -r f; do
  git show ":$f" | grep -qiE '(password|secret|token|api_key)[[:space:]]*=[[:space:]]*"?[A-Za-z0-9]' && { echo "pre-commit: mögliches Geheimnis in $f"; exit 1; }
done
H
chmod +x .git/hooks/pre-commit
echo 'api_key = "Beispiel-Geheim-3"' > neu.py; git add neu.py
git commit -q -m "Versuch" 2>&1 | head -2; echo "Rückgabecode des Commits: ${PIPESTATUS[0]}"
cd /; lab_down
