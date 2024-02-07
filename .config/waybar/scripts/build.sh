#!/usr/bin/env bash

# Convert sass files to a css file for Waybar

dir=$(dirname $0)
sass ${dir}/../scss/style.scss > ${dir}/../style.css