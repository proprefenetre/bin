#!/usr/bin/env bash

TMPFILE="$(mktemp)"
trap "rm -f '$TMPFILE'" 0               # EXIT
trap "rm -f '$TMPFILE'; exit 1" 2       # INT
trap "rm -f '$TMPFILE'; exit 1" 1 15    # HUP TERM

cmd="$1"
file="$2"

cat $file >> "$TMPFILE"

$cmd $TMPFILE

