#!/usr/bin/bash
set -eu

[[ $# -eq 0 ]] && echo "No arguments supplied" 

DIR=$HOME/$1

if [[ -d $DIR ]]; then
    echo "$DIR exists"
    cd $DIR
else
    mkdir -p $DIR
    cd $DIR
fi
