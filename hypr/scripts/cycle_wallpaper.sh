#!/bin/bash

# 1. Put your Wallpaper Engine Workshop IDs here
WALLPAPERS=(
    "1415580658"
    "3249931720"
    "3289551080"
    "3352342968"
    "2863911519"
    "827148653"
)

# File to remember which wallpaper is currently active
INDEX_FILE="$HOME/.cache/wallpaper_engine_index"

# Read the current index, default to 0 if the file doesn't exist
if [ -f "$INDEX_FILE" ]; then
    CURRENT_INDEX=$(cat "$INDEX_FILE")
else
    CURRENT_INDEX=0
fi

# Calculate the next index (loops back to 0 when it reaches the end)
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#WALLPAPERS[@]} ))

# Save the new index for the next time the script is run
echo "$NEXT_INDEX" > "$INDEX_FILE"

# Get the ID of the next wallpaper
NEXT_WALLPAPER="${WALLPAPERS[$NEXT_INDEX]}"

# Kill any currently running instance of linux-wallpaperengine
pkill -f "linux-wallpaperengine"
sleep 0.5 # Brief pause to ensure the port is freed

# Launch the new wallpaper (using your eDP-1, fill scaling, and silent arguments)
linux-wallpaperengine --screen-root eDP-1 --scaling fill --volume 100 --noautomute "$NEXT_WALLPAPER" &

# Optional: Send a desktop notification so you know it worked
notify-send "Wallpaper Engine" "Switched to ID: $NEXT_WALLPAPER"
