#!/usr/bin/env bash
# Modul 7 (Priorität 2): Anmeldeschutz prüfen. Nur eigene Beispielanwendung auf Loopback, nur wenige Fehlversuche mit festem falschem Kennwort.
. "$(dirname "$0")/../lab.sh"
lab_up
login() { curl -s -o /dev/null -w '%{http_code}' -d "user=$1" -d "pw=$2" 127.0.0.1:$3/login; }
step "1. Dienst ohne Sperre (Port $APP): sechs Fehlversuche mit demselben falschen Kennwort"
for i in 1 2 3 4 5 6; do echo "Versuch $i: $(login demo falsch-1 $APP)"; done
echo "Danach richtiges Kennwort: $(login demo Beispiel-Pw-1 $APP) (200 = angemeldet)"
step "2. Dienst mit Sperre nach 3 Fehlversuchen (Port $APP2)"
for i in 1 2 3 4 5 6; do echo "Versuch $i: $(login demo falsch-1 $APP2)"; done
echo "Danach richtiges Kennwort: $(login demo Beispiel-Pw-1 $APP2) (429 = gesperrt)"
step "3. Sperre trifft das Konto, nicht den Angreifer: anderer Benutzername ist nicht gesperrt"
echo "Benutzer anna, falsch: $(login anna falsch-1 $APP2)"
step "4. Bewertung (Modell)"
cat <<'T'
Ohne Sperre   : unbegrenzt viele Versuche; Schutz nur durch die Stärke des Kennworts
Sperre je Konto: bremst Raten, erlaubt aber gezielte Aussperrung eines Benutzers (Denial of Service)
Besser         : wachsende Wartezeit, Begrenzung je Quelladresse und je Konto, Mehr-Faktor, Meldung an die Überwachung
T
step "5. Grenze der Übung"
echo "Es werden keine Kennwortlisten und keine Fremdsysteme verwendet; die Übung prüft nur, ob der eigene Dienst begrenzt."
