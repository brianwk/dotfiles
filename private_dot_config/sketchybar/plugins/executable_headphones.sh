
AUDIO_OUTPUT_DEVICE=$(SwitchAudioSource -c)
BLUETOOTH_DEVICE=$(blueutil --paired --format json|jq -r '.[] | select(.name == "ATH-M50xBT2") | .name')

if [[ "$AUDIO_OUTPUT_DEVICE" == "$BLUETOOTH_DEVICE" ]]; then
   sketchybar --set headphones drawing=on label="$AUDIO_OUTPUT_DEVICE" icon="󰥰" icon.font.size=32
else
   sketchybar --set headphones drawing=off
fi
