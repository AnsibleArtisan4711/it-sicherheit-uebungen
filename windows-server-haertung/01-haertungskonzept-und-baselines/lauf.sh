#!/usr/bin/env bash
# Vergleicht die Beispiel-Sicherheitsvorlage mit der Baseline-Tabelle (Python 3).
cd "$(dirname "$0")" || exit 1
python3 baseline_vergleich.py sicherheit.inf baseline.csv
