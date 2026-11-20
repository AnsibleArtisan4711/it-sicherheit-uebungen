#!/usr/bin/env bash
# Prüft den Beispiel-Patchstand (Python 3).
cd "$(dirname "$0")" || exit 1
python3 patch_stand.py patchstand.csv
