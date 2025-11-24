
AUDIO_OUTPUT_DEVICE=$(SwitchAudioSource -c)
BLUETOOTH_DEVICE=$(blueutil --paired --format json|jq -r '.[] | select(.name == "ATH-M50xBT2") | .name')
BATTERY_PERCENT=$(pmset -g accps|grep 'ATH-M50xBT2' | cut -f '2-3'|ggrep -Po '[0-9]+')
if [[ "$AUDIO_OUTPUT_DEVICE" == "$BLUETOOTH_DEVICE" ]]; then
  sketchybar --set headphones drawing=on label.drawing=off label="$AUDIO_OUTPUT_DEVICE" icon="󰥰" icon.font.size=32 background.drawing=off
  sketchybar --set headphones_battery drawing=on label="$BATTERY_PERCENT%" label.color=0x22f0f0f0f0 background.drawing=off label.font.size=10 label.y_offset=-10 label.padding_left=0
else
   sketchybar --set headphones drawing=off
   sketchybar --set headphones_battery drawing=off
fi
