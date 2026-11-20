#!/usr/bin/env bash
# Vergleicht die Beispiel-Überwachungsrichtlinie mit dem Soll (Python 3).
cd "$(dirname "$0")" || exit 1
python3 audit_vergleich.py audit_ist.csv audit_soll.csv
