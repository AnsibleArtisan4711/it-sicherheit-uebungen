#!/usr/bin/env bash
# Prüft die Beispiel-Anmeldeliste gegen das Tier-Modell (Python 3).
cd "$(dirname "$0")" || exit 1
python3 tier_pruefung.py anmeldungen.csv
