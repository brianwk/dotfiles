#!/bin/bash
DISPLAYS_JSON=$(rift-cli query displays)
CURRENT_DISPLAY=$(echo $DISPLAYS_JSON | jq -r 'to_entries.[]|select(.value.is_active_context)')
DISPLAY_COUNT=$(echo $DISPLAYS_JSON | jq 'length')
OFFSET_DISPLAY_COUNT=$(($DISPLAY_COUNT - 1))
echo "Current Display:" $CURRENT_DISPLAY
echo "No. Displays:" $DISPLAY_COUNT
echo "Offset Display Count:" $OFFSET_DISPLAY_COUNT
MAX_KEY=$(python3 -c "print(max("$OFFSET_DISPLAY_COUNT", 0))")
CURRENT_DISPLAY_KEY=$(echo $CURRENT_DISPLAY | jq -r '.key')
echo "Current Display Key: " $CURRENT_DISPLAY_KEY

if [[ $CURRENT_DISPLAY_KEY -ge $MAX_KEY ]]; then
  NEXT_KEY=0
else
  NEXT_KEY=$(($CURRENT_DISPLAY_KEY + 1))
fi

echo "Next Display Key: "$NEXT_KEY

rift-cli execute display move-mouse-to-index $NEXT_KEY
