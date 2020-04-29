#!/usr/bin/env bash

id=$(xdotool search --classname scratchterm)

if [ -z "$id" ]; then
    # urxvt -name scratchterm
    kitty --name scratchterm
    id=$(xdotool search --classname scratchterm)
fi

cur_monitor=$(bspc query -M -m focused)

bspc node "$id" --flag "hidden" -m "$cur_monitor" -f
