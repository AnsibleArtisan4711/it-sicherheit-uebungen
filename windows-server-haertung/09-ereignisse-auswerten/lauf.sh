#!/usr/bin/env bash
# Wertet Beispiel-Sicherheitsereignisse aus (Python 3).
cd "$(dirname "$0")" || exit 1
python3 ereignisse_auswerten.py ereignisse.csv
