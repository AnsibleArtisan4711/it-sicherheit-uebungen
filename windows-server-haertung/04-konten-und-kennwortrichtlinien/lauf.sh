#!/usr/bin/env bash
# Prüft den Beispiel-Konten-Export (Python 3).
cd "$(dirname "$0")" || exit 1
python3 konten_pruefen.py konten_export.csv
