#!/bin/bash

# strict mode:
set -e -u

loadkeys dvorak
ping -c1 google.com
timedatectlset-ntp true
