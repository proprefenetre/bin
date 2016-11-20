#!/bin/bash

# strict mode:
set -e -u

IFS=$(echo -en "\n\b");
for i in *.MTS; do
    fname=$(basename "$i" .MTS)
    ffmpeg -i "$i" -an "$fname.mp4"
done
