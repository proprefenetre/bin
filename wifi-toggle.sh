#!/usr/bin/env bash

connmanctl disable wifi >/dev/null 2>&1 && echo 'wifi OFF'
sleep 3
connmanctl enable wifi >/dev/null 2>&1 && echo 'wifi ON'

