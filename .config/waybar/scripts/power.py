#!/usr/bin/env python

import os
import json
import subprocess

def get_battery():
    for file in os.listdir("/sys/class/power_supply/"):
        if file.startswith("BAT"):
            return f"/sys/class/power_supply/{file}"
    return None

def get_psu():
    for file in os.listdir("/sys/class/power_supply/"):
        if file.startswith("ADP"):
            return f"/sys/class/power_supply/{file}"
    return None

def main():
    bat = get_battery()
    psu = get_psu()

    if bat is None or psu is None:
        print("{}")
        return

    with open(f"{bat}/capacity") as f:
        capacity = int(f.read().strip())

    with open(f"{psu}/online") as f:
        online = int(f.read().strip())

    # Get icon from the capacity and status
    icon = ""
    if online == 1:
        icon += "<span color='#8ec07c'></span>  "
    
    if capacity < 20:
        icon += "<span color='#fe8019'></span>"
    elif capacity < 40:
        icon += ""
    elif capacity < 60:
        icon += ""
    elif capacity < 80:
        icon += ""
    else:
        icon += ""

    print(json.dumps({
        "text": icon,
        "percentage": capacity
    }, ensure_ascii = False))

if __name__ == "__main__":
    main()
