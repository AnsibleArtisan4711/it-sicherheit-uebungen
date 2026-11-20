#!/usr/bin/env bash
# Priorisiert die Beispielbefunde (Python 3).
cd "$(dirname "$0")" || exit 1
python3 priorisieren.py befunde.csv assets.csv
