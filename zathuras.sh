#!/usr/bin/env bash

[[ $# -lt 1 ]] && echo "missing file name" && exit 1

zathura $1 &
