#!/usr/bin/env bash

connmanctl disable wifi && echo 'wifi OFF'
sleep 3
connmanctl enable wifi && echo 'wifi ON'

