#! /usr/bin/env bash

# -N: list the IDs of the matching nodes
# -n: constrain matches to the selected node
wid=$(bspc query -N -n)
notify-send "state" $(bspc query -T -n "$wid" | jq -r ".client.state")

