#! /usr/bin/env bash

id=$(xinput | rg -i ".*kensington.*id=([0-9]+).*" -r '$1')

if [[ -f /tmp/precision-mode ]]; then
    xinput set-prop "$id" 'libinput Accel Speed' -0.5
    xinput set-prop "$id" 'libinput Accel Profile Enabled' 0, 1
    rm -f /tmp/precision-mode
    notify-send -a "trackball" "precision mode" "off"
else
    xinput set-prop "$id" 'libinput Accel Speed' -0.95
    xinput set-prop "$id" 'libinput Accel Profile Enabled' 0, 1
    touch /tmp/precision-mode
    notify-send -a "trackball" "precision mode" "on"
fi
