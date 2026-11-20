#!/usr/bin/env bash
# Gemeinsame Hilfen der Übungsreihe (P63). Es werden nur erfundene Beispielwerte verwendet; alle Dateien liegen unter /tmp/p63.
W=/tmp/p63
step() { echo; echo "## $*"; }
cmd() { echo "\$ $*"; "$@" 2>&1; return $?; }
lab_up() { lab_down >/dev/null 2>&1; mkdir -p "$W"; }
lab_down() { rm -rf "$W"; }
