#! /usr/bin/env bash

# add subuids (?) for rootless podman builds

sudo touch /etc/sub{u,g}id
sudo usermod --add-subuids 10000-75535 $(whoami)
sudo usermod --add-subgids 10000-75535 $(whoami)
# rm /run/user/$(id -u)/libpod/pause.pid
