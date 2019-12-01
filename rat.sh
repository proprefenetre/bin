#! /usr/bin/env bash

# Kensington Expert

mouse_id=$(xinput | rg "Kensington.*id=([0-9]+)" -r '$1' -o | head -n 1)

xinput set-button-map "$mouse_id" 2 1 6 4 5 7 8 3 9
xinput set-prop "$mouse_id" 'libinput Accel Speed' -0.3
xinput set-prop "$mouse_id" 'libinput Accel Profile Enabled' 0, 1
