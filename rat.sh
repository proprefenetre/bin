#! /usr/bin/env bash

# Kensington Expert

mouse_id=$(xinput | rg "Kensington.*id=([0-9]+)" -r '$1' -o | head -n 1)

case $1 in
    -e|--expert)     
        # xinput set-button-map "$mouse_id" 2 1 3 4 5 7 8 6 9
        xinput set-prop "$mouse_id" 'libinput Accel Speed' -0.1
        xinput set-prop "$mouse_id" 'libinput Accel Profile Enabled' 1, 0
        ;;

    -o|--orbit)
        xinput set-button-map "$mouse_id" 1 2 3 4
        xinput set-prop "$mouse_id" 'libinput Accel Speed' -0.1
        xinput set-prop "$mouse_id" 'libinput Accel Profile Enabled' 0, 1
        ;;

    -d|--debug)
        echo "$mouse_id"
        ;;
esac


