#! /usr/bin/env bash

key=""
while [[ $# -gt 0 ]]
do
    elem="$1%2C"
    key="$key$elem"
    shift
done

curl "https://www.gitignore.io/api/${key%%%2C}" -o .gitignore
