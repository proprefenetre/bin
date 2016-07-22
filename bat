#!/bin/bash

FULL=$(</sys/class/power_supply/BAT0/energy_full_design)
NOW=$(</sys/class/power_supply/BAT0/energy_now)
BATTERY_LEVEL=$(echo "scale=2; $NOW/$FULL" | bc)

echo "$BATTERY_LEVEL (NOTE: this is broken)"
