#! /usr/bin/env bash

mouse_id=$(xinput | rg -i "kensington.*id=([0-9]+)" -r '$1' -o | head -n 1)

if [[ -f /tmp/precision-mode ]]; then
    xinput set-prop "$mouse_id" 'libinput Accel Speed' -0.3
    xinput set-prop "$mouse_id" 'libinput Accel Profile Enabled' 0, 1
    rm -f /tmp/precision-mode
    notify-send -a "trackball" "precision mode" "off"
else
    xinput set-prop "$mouse_id" 'libinput Accel Speed' -0.85
    xinput set-prop "$mouse_id" 'libinput Accel Profile Enabled' 0, 1
    touch /tmp/precision-mode
    notify-send -a "trackball" "precision mode" "on"
fi
