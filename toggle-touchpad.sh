#!/bin/sh

for dev in $(xinput | rg -i ".*touchpad.*id=([0-9]+).*" -r '$1'); do
    state=$(xinput list-props "$dev" | grep "Device Enabled" | awk '{print $4}')
    # echo "$dev: $state"
    if [ "$state" -eq 1 ] ; then
        xinput disable "$dev"
        notify-send -a "Touchpad" " " "Disabled"
    else
        xinput enable "$dev"
        notify-send -a "Touchpad" " " "Enabled"
    fi
done

