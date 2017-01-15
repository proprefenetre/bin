#!/usr/bin/env bash

# print a line of equal length below a string

pad=$(printf '%0.1s' ${2:--}{1..60})
padlength=0
printf '\n%s\n' "$1"
printf '%*.*s\n' 0 $((padlength + ${#1})) "$pad"
