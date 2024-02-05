#!/usr/bin/env bash

# For computers that discharge from a battery
function print_battery {
    # First argument is the name of the battery (i.e: BAT0)
    battery_name="$1"
    device="/sys/class/power_supply/$battery_name"

    # Get capacity and status
    capacity=$(cat "$device/capacity")
    status=$(cat "$device/status")

    # Get the power and convert the micro-watts to watts
    pwr_draw_uw=$(cat "$device/power_now")
    pwr_draw=$(bc <<< "scale=2; $power_uw / 1000000")

    # Generate a battery icon
    if [[ $status == "Charging" ]]; then
        # No need for a battery icon so show a lighting bolt
        icon=""
    elif [[ $capacity == 100 ]]; then
        icon=""
    elif [[ $capacity -ge 75 ]]; then
        icon=""
    elif [[ $capacity -ge 50 ]]; then
        icon=""
    elif [[ $capacity -ge 25 ]]; then
        icon=""
    else
        icon=""
    fi

    # Print output
    wattage=$(printf "%05.2f" "$pwr_draw")
    printf "$icon $capacity% @ ${wattage}W"
}

# For computers that get power directly from a power supply
# Will 100% need some tweaking on other systems, I only wrote this for my own systems
function print_psu {
    # We can't measure the complete power draw of the computer.
    # We can print the power draw of the CPU and GPU though, but it's not worth
    # calculating every little thing.

    # Get the power draw of the Cores + SoC using zenpower
    # Only for Ryzen CPUs that support SVI2
    cpu_pwr_draw=$(sensors zenpower-pci-00c3 | awk '/^SVI2_.+W/ { total += $2 } END { print total }')

    # Get the power draw of the GPU (AMDGPU)
    # You need AMDGPU drivers for this to work
    gpu1_pwr_draw=$(sensors amdgpu-pci-0400 | awk '/^PPT/ { print $2 }')

    # Too lazy to add my 2nd GPU (NVIDIA) i just need this to work on my laptop and
    # desktop. If you need a pointer for NVIDIA, you can use nvidia-smi
    # Would be ideal to write this in something like C to make it easier to work with

    # Print output (made it a bit nicer so the bar isnt janky when the wattage is between 0 and 99)
    cpu_wattage=$(printf "%05.2f" "$cpu_pwr_draw")
    gpu1_wattage=$(printf "%05.2f" "$gpu1_pwr_draw")
    printf " ${cpu_wattage}W 󰍹 ${gpu1_wattage}W"
}

# Detect battery
battery_name=$(ls /sys/class/power_supply | grep BAT)

# Print output
if [[ -n $battery_name ]]; then
    print_battery "$battery_name"
else
    print_psu
fi