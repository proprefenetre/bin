#! /usr/bin/env bash

if [[ -f /tmp/hidden-window ]]; then
    wid=$(cat /tmp/hidden-window)
    xdo show "$wid"
    rm -f /tmp/hidden-window
else
    wid=$(bspc query -N -n)
    xdo hide "$wid"
    echo "$wid" > /tmp/hidden-window
fi
