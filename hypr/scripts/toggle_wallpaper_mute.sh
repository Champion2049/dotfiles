#!/bin/bash

FOUND=0

# Get all wallpaper-related stream IDs
STREAM_IDS=$(pactl list sink-inputs | awk '
/Sink Input #/ {id=$3}
/application\.name =/ {
    if ($0 ~ /SDL Application|mpv/) print id
}
' | tr -d '#')

if [ -z "$STREAM_IDS" ]; then
    notify-send "Wallpaper Engine" "No wallpaper audio streams found."
    exit 1
fi

for ID in $STREAM_IDS; do
    pactl set-sink-input-mute "$ID" toggle
    FOUND=1
done

# Check state of last stream for notification
LAST_ID=$(echo "$STREAM_IDS" | tail -n1)

IS_MUTED=$(pactl list sink-inputs | awk -v id="#$LAST_ID" '
$0 ~ id {found=1}
found && /Mute:/ {print $2; exit}
')

if [ "$IS_MUTED" = "yes" ]; then
    notify-send "Wallpaper Engine" "Audio Muted."
else
    notify-send "Wallpaper Engine" "Audio Unmuted."
fi
