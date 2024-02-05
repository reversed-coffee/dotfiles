#!/bin/bash

# Run some stuff when kanshi triggers
# Basically move workspaces all around the placey

displays_raw=$(wlr-randr | grep -v "^\s")

# Attempt to find monitors

disp_1=$(echo "$displays_raw" | grep "BOE NE160WUM-NX2" | cut -d' ' -f1)
disp_2=$(echo "$displays_raw" | grep "Dell Inc. DELL S2319NX 1LV6T03" | cut -d' ' -f1)
disp_3=$(echo "$displays_raw" | grep "Dell Inc. DELL S2319NX 4027T03" | cut -d' ' -f1)

# If 3rd is available but not 2nd, 3rd takes place of 2nd
# disp_1 is always going to exist because its embedded

# This will be in cases where I may unplug a monitor for use with
# a secondary computer

if [ -z "$disp_2" ] && [ -n "$disp_3" ]; then
    disp_2="$disp_3"
    disp_3=""
    disp_2_horizontal=1
fi

# The primary monitor is going to be the rightmost physically
# Displays 1, 2, and 3 are set up from left-to-right on my desk
# Two is vertical, but it is used as a secondary due to the layout

if [ -n "$disp_3" ]; then
    disp_primary="$disp_3"
    disp_secondary="$disp_2"
    disp_tertiary="$disp_1"
elif [ -n "$disp_2" ]; then
    if [ -z "$disp_2_horizontal" ]; then
        # Here i would prefer the horizontal as a primary
        disp_primary="$disp_1"
        disp_secondary="$disp_2"
    else
        disp_primary="$disp_2"
        disp_secondary="$disp_1"
    fi
else
    disp_primary="$disp_1"
fi

# Variable for all displays

disp_all="$disp_primary $disp_secondary $disp_tertiary"
echo $disp_all

# We're going to tell sway to bind workspaces to our primary
# and we're only going to give 1 to the secondary and tertiary

# Cache workspace
current_workspace=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused==true).name')

# Set the workspaces on the primary display
swaymsg "workspace 1; move workspace to output $disp_primary"
swaymsg "workspace 2; move workspace to output $disp_primary"
swaymsg "workspace 3; move workspace to output $disp_primary"
swaymsg "workspace 4; move workspace to output $disp_primary"
swaymsg "workspace 5; move workspace to output $disp_primary"
swaymsg "workspace 6; move workspace to output $disp_primary"
swaymsg "workspace 7; move workspace to output $disp_primary"
swaymsg "workspace 8; move workspace to output $disp_primary"

# Set the workspace on the secondary display, if it exists
if [ -n "$disp_secondary" ]; then
    swaymsg "workspace 9; move workspace to output $disp_secondary"
fi

# Set the workspace on the tertiary display, if it exists
if [ -n "$disp_tertiary" ]; then
    swaymsg "workspace 10; move workspace to output $disp_tertiary"
fi

# Focus to cache
swaymsg "workspace $current_workspace"

# Reload waybar
export disp_primary
export disp_secondary
export disp_tertiary
export disp_all

bash $(dirname $0)/bar.sh
