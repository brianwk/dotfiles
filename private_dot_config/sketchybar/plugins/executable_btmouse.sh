MOUSE_CONNECTED=$(blueutil --info "MX Anywhere 3S" --format json | jq '.connected')

if [[ "$MOUSE_CONNECTED" == "true" ]]; then
   sketchybar --set btmouse drawing=on label.drawing=off icon="󰦋" icon.font.size=24
else
   sketchybar --set btmouse drawing=off
fi
