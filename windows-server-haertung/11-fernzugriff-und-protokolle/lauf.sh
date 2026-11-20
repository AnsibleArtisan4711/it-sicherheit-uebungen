#!/usr/bin/env bash
# Prüft Beispiel-Einstellungen für Fernzugriff und Protokolle (Python 3).
cd "$(dirname "$0")" || exit 1
python3 remote_pruefen.py remote_einstellungen.csv
