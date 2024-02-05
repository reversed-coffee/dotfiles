#!/bin/bash
# dump the environment to sway's configuration

printenv | awk -F= '{printf "set $env_%s %s\n", $1, $2}' \
    > $HOME/.config/sway/config.d/00-envdump.conf