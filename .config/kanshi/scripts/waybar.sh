#!/usr/bin/env bash

envsubst < $HOME/.config/waybar/config > $HOME/.config/waybar/.patched-config
killall waybar 2> /dev/null
/usr/bin/waybar --config $HOME/.config/waybar/.patched-config &
disown