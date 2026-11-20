#!/usr/bin/env bash
# Prüft die Beispiel-Zielliste gegen die Freigabe (Python 3).
cd "$(dirname "$0")" || exit 1
python3 scan_freigabe.py freigabe.csv
