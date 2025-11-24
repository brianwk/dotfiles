MOUSE_CONNECTED=$(blueutil --info "MX Anywhere 3S" --format json | jq '.connected')
BATTERY_PERCENT=$(pmset -g accps|grep 'MX Anywhere 3S' | cut -f '2-3'|ggrep -Po '[0-9]+')

if [[ "$MOUSE_CONNECTED" == "true" ]]; then
   sketchybar --set btmouse drawing=on label.drawing=off icon="󰦋" icon.font.size=24 label.padding_right=0
   sketchybar --set btmouse_battery drawing=on label="$BATTERY_PERCENT%" label.color=0x22f0f0f0f0 background.drawing=off label.font.size=10 label.y_offset=-10 label.padding_left=0
else
   sketchybar --set btmouse drawing=off
fi
