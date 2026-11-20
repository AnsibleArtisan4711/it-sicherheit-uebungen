#!/usr/bin/env bash
# Prüft die Beispiel-Firewall-Regeln (Python 3).
cd "$(dirname "$0")" || exit 1
python3 firewall_pruefen.py firewall_regeln.csv
