#!/usr/bin/env bash
# Prüft LAPS-Ablaufzeiten im Beispiel-Export und erzeugt ein Kennwort (Python 3).
cd "$(dirname "$0")" || exit 1
python3 laps_pruefen.py computer_export.csv
echo
python3 laps_pruefen.py --passwort
