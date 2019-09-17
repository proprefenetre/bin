#! /usr/bin/env bash

id=$(xinput | rg -i ".*kensington.*id=([0-9]+).*" -r '$1')

xinput set-prop "$id" 'libinput Accel Speed' -0.5
xinput set-prop "$id" 'libinput Accel Profile Enabled' 0, 1
