#! /usr/bin/env bash

# IFS=$(echo -en "\n\b");
# for i in *.MTS; do
[[ $# -lt 1 ]] && echo "gimme a file" && exit 1

fname=$(basename "$1" .MTS)

ffmpeg -i "$1" -an "$fname.mp4"
