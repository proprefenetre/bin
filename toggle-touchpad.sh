#!/bin/sh

ID=$(xinput list | grep -Eio '(touchpad|glidepoint)\s*id\=[0-9]{1,2}' | grep -Eo '[0-9]{1,2}')

STATE=$(xinput list-props $ID|grep 'Device Enabled'|awk '{print $4}')

if [ $STATE -eq 1 ] ; then
    xinput disable $ID
    notify-send -a 'Touchpad' 'Disabled'
else
    xinput enable $ID
    notify-send -a 'Touchpad' 'Enabled'	 
fi
