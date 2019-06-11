#! /usr/bin/env bash

usage () { echo "$(basename $0) <src> <dest>" >/dev/stderr; }

src="$1"
dest="$2"

[[ -r "$src" ]] || error "Source should be readable"

cd "$(dirname $src)"
src="$(basename $src)"

# convert .MTS to .mp4 (without sound)
IFS=$(echo -en "\n\b");
for i in "$src"/*.MTS; do
    fname="$(date --date="$src" "+%a-%d-%m-%Y")_$(basename "$i" .MTS).mp4"
    ffmpeg -i "$i" -an "$dest/$fname"
done

