#! /usr/bin/env bash

screenshots_dir="$HOME/files/shots"

cd "$screenshots_dir"
scrot &&
    notify-send -a "Shots fired" "Screenshot saved to $screenshots_dir"
