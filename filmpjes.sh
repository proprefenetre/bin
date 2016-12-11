#! /usr/bin/env bash
# set -e -u

usage () { echo "$(basename $0) <src> <cadaver-args>" >/dev/stderr; }
error () { echo "$1" >/dev/stderr; usage; exit 1; }

# dav="https://proprefenetre.stackstorage.com/remote.php/webdav/"

# [[ $# < 3 ]] || error "Source and cadaver arguments are required!"

src="$1"; shift;    # $1 is now target
[[ -r "$src" ]] || error "Source should be readable"

cd "$(dirname $src)"
src="$(basename $src)"

# convert .MTS to .mp4 (without sound)
IFS=$(echo -en "\n\b");
for i in $src/*.MTS; do
    fname="$(date --date="$src" "+%a-%d-%m-%Y")_$(basename "$i" .MTS).mp4"
    ffmpeg -i "$i" -an "$src/$fname"
    rm "$i"
done

