#!/usr/bin/env bash
# Vergleicht den Beispiel-Dienste-Export mit der Rolle Dateiserver (Python 3).
cd "$(dirname "$0")" || exit 1
python3 dienste_pruefen.py dienste_export.csv rolle_dateiserver.csv
