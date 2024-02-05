#!/bin/bash
# Compile, patch, and start

envsubst < $HOME/.config/waybar/partial.jsonc > \
    $HOME/.config/waybar/config
killall waybar 2> /dev/null

waybar & 
disown