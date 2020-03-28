#! /usr/bin/env bash

pkill -USR1 -x sxhkd && echo "$(date) - reload config" >> ~/.config/sxhkd/log && notify-send "sxhkd" "reloaded config"
