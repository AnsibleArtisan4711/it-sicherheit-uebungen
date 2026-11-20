#!/usr/bin/env bash
# Wertet den Beispielbericht aus (Python 3).
cd "$(dirname "$0")" || exit 1
python3 bericht_auswerten.py beispiel_bericht.csv
