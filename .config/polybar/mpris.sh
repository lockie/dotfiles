#!/usr/bin/env sh

icon=""

player_status=$(playerctl status 2> /dev/null)
# shellcheck disable=SC2181
if [ $? -eq 0 ]; then
    metadata="$(playerctl metadata artist) - $(playerctl metadata title)"
fi

# Foreground color formatting tags are optional
if [ "$player_status" = "Playing" ]; then
    echo "%{F#D08770}$icon $metadata"       # Orange when playing
elif [ "$player_status" = "Paused" ]; then
    echo "%{F#65737E}$icon $metadata"       # Greyed out info when paused
else
    echo "%{F#65737E}$icon"                 # Greyed out icon when stopped
fi
