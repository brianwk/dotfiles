
MOUSE_PAIRED=$(blueutil --info "MX Anywhere 3S" --format json | jq '.paired')

if [[ "$MOUSE_PAIRED" == "true" ]]; then
   sketchybar --set btmouse drawing=on label.drawing=off icon="󰦋" icon.font.size=28
else
   sketchybar --set btmouse drawing=off
fi
