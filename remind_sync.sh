#! /usr/bin/env bash

# make a copy of the remind script, because the webdav mount depends too much
# on an internet connection to be reliable for symlinking

while true; do
    unison reminders -batch >/dev/null 2>&1 
    sleep 10s
done
