#!/usr/bin/env python

# parse content from playerctl and output json

import sys
import re
import json
import subprocess

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

def parse_metadata(str):
    metadata={}

    if len(str) == 0:
        exit()

    for match in re.findall("(?m)^spotify\s+([A-z_-]+):([A-z_-]+)\s+(.+)$", str):
        if len(match) != 3:
            eprint("Skipping" + match + " (Not enough matches)")
            continue

        category = match[0]
        key = match[1]
        value = match[2]

        if not category in metadata:
            metadata[category] = {}

        metadata[category][key] = value

    return metadata

def get_metadata():
    metadata_request = subprocess.Popen([ "playerctl", "-p", "spotify", "metadata" ],
        stdout = subprocess.PIPE)
    raw_metadata = metadata_request.communicate()[0].decode("utf-8")
    return parse_metadata(raw_metadata)
    
def get_status():
    status_request = subprocess.Popen([ "playerctl", "-p", "spotify", "status" ],
        stdout = subprocess.PIPE)
    status = status_request.communicate()[0].decode("utf-8")
    return status.lower().replace("\n", "")

def main():
    metadata = get_metadata()
    status = get_status()

    print(json.dumps({
        # did a quick patch here to get ampersands working but im too lazy for other stuff
        "text": (metadata["xesam"]["title"] + " - " + metadata["xesam"]["artist"]).replace("&", "&amp;"),
        "class": status
    }))

if __name__ == "__main__":
    main()
