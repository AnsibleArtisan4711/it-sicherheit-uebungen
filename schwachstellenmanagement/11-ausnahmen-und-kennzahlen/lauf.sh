#!/usr/bin/env bash
# Prüft das Beispiel-Ausnahmeregister und berechnet Kennzahlen (Python 3).
cd "$(dirname "$0")" || exit 1
python3 ausnahmen_pruefen.py ausnahmen.csv
echo
python3 kennzahlen.py befunde_verlauf.csv
