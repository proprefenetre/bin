#!/usr/bin/env sh

# find and replace crlf's in files found under directory $dir


usage () {
    echo "Usage: $(basename "$0") [directory]"
    exit 1
}


if [[ "$#" -lt 1 ]]; then
    usage
else
    if [[ ! -d "$1" ]]; then
        usage
    fi
fi

find "$1" -type f -printf "convert %p\n" -exec perl -pi -e 's/\r\n/\n/g' {} \;
