#! /usr/bin/env bash

# Curses or tiles
VERSION="Curses"

curl -sL $(curl -s https://api.github.com/repos/CleverRaven/Cataclysm-DDA/releases | jq ".[0].assets | map(select(.label==\"Linux_x64 ${VERSION}\")) | .[].browser_download_url" | rg -o '[^"]+') | tar xz
