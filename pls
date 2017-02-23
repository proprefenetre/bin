#!/usr/bin/env bash

# open a playlist file with mpv without having to specify the --playlist=
# option

[ ! $# -eq 1 ] && echo "specify a playlist" && exit 1

mpv --playlist=$1
