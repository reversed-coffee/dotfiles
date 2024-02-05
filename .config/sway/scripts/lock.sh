#!/bin/bash
set -euo pipefail

# lock.sh
# swaylock wrapper that blurs the screen

# Tell magick to use OpenCL which can potentially speed up blurring
export MAGICK_OCL_DEVICE=true

# Get the current args to pass to swaylock
swaylock_args="$@"

# Generate a temporary directory on the RAM for lock images
lock_images=$(mktemp -d -t swaylock.XXXXXX -p /dev/shm)

# Security: Make the directory unreadable to groups and others
chmod 700 "$lock_images"

# Get all outputs on the computer
outputs=$(swaymsg -t get_outputs | jq -r '.[] | .name')

# Take screenshots in parallel and wait
# I did 0.85 scale here because anything lower will make weird annd ugly
# edges. I also avoided compression because that would maek this command
# much slower.
for output in $outputs; do
    grim -o "$output" -t png -l 0 -s 0.85 "${lock_images}/${output}" &
done
wait

# Apply blur in parallel and wait for them to finish
# Additionally construct cli arguments for swaylock
for output in $outputs; do
    convert "${lock_images}/${output}" -scale 10% -blur 0x2.5 \
        -resize 1000% "${lock_images}/${output}-blur" &
    swaylock_args+=" -i $output:${lock_images}/${output}-blur"
done
wait

# Execute swaylock
swaylock $swaylock_args

# Delete the temproary directory
rm -rf "$lock_images"