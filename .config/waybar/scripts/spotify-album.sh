#!/bin/bash

album_art=$(playerctl -p spotify metadata mpris:artUrl)

if [[ -z $album_art ]]; then
   exit
fi

last_art=$(cat /tmp/cover.url 2> /dev/null)

if [[ $album_art != $last_art ]]; then
    curl -s "$(echo "$album_art" | sed 's/https/http/')" --output "/tmp/cover.jpeg"
fi

echo "$album_art" > /tmp/cover.url
echo "/tmp/cover.jpeg"