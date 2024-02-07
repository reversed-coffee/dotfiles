#!/usr/bin/env bash

# Run some stuff when kanshi triggers
# Basically move workspaces all around the place

# Attempt to find monitors
displays_raw=$(wlr-randr | grep -v "^\s")
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
    export PRIMARY_DISPLAY="$disp_3"
    export SECONDARY_DISPLAY="$disp_2"
    export TERTIARY_DISPLAY="$disp_1"
elif [ -n "$disp_2" ]; then
    if [ -z "$disp_2_horizontal" ]; then
        # Here i would prefer the horizontal as a primary
        export PRIMARY_DISPLAY="$disp_1"
        export SECONDARY_DISPLAY="$disp_2"
    else
        export PRIMARY_DISPLAY="$disp_2"
        export SECONDARY_DISPLAY="$disp_1"
    fi
else
    export PRIMARY_DISPLAY="$disp_1"
fi

# Variable for all displays

export ALL_DISPLAYS="$PRIMARY_DISPLAY $SECONDARY_DISPLAY $TERTIARY_DISPLAY"
echo "------------------------------------"
echo "Available displays: $ALL_DISPLAYS"
echo "    - Primary:   $PRIMARY_DISPLAY"
echo "    - Secondary: $SECONDARY_DISPLAY"
echo "    - Tertiary:  $TERTIARY_DISPLAY"
echo "------------------------------------"

# We're going to tell sway to bind workspaces to our primary
# and we're only going to give 1 to the secondary and tertiary

# Cache workspace
export FOCUSED_WORKSPACE=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused==true).name')

# Set the workspaces and hide stdout because some workspaces may not exist and thats OK
swaymsg """
workspace 1; move workspace to output $PRIMARY_DISPLAY
workspace 2; move workspace to output $PRIMARY_DISPLAY
workspace 3; move workspace to output $PRIMARY_DISPLAY
workspace 4; move workspace to output $PRIMARY_DISPLAY
workspace 5; move workspace to output $PRIMARY_DISPLAY
workspace 6; move workspace to output $PRIMARY_DISPLAY
workspace 7; move workspace to output $PRIMARY_DISPLAY
workspace 8; move workspace to output $PRIMARY_DISPLAY
workspace 9; move workspace to output ${SECONDARY_DISPLAY:=PRIMARY_DISPLAY}
workspace 10; move workspace to output ${TERTIARY_DISPLAY:=PRIMARY_DISPLAY}
workspace $FOCUSED_WORKSPACE
""";

# Reload waybar
$HOME/.config/kanshi/scripts/waybar.sh
