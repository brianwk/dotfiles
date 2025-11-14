#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/rift.sh

RIFT_CLI="/Users/briankaplan/dev-current/rift/target/debug/rift-cli"

# If a specific workspace was passed as argument, handle its visibility
if [ -n "$1" ]; then
    workspace_id="$1"
    # parse name space.x.y where x is workspace ID and y is monitor ID
    monitor=$(echo $NAME | cut -d'.' -f3)
    display_uuid=$(sketchybar --query displays | jq -r '.[] | select(."arrangement-id" == '$monitor') | .UUID')
    echo "uuid:" $display_uuid;
    display_space=$($RIFT_CLI query displays | jq -r '.[] | select(.uuid == "'$display_uuid'") | .space')
    echo "display space: " $display_space;
    visible_workspace=$($RIFT_CLI query workspaces --space-id "$display_space" | jq -r '.[] | select(.is_active) | .index')
    echo "visible: " $visible_workspace;
    if [ "$workspace_id" = "$visible_workspace" ]; then
      sketchybar --set $NAME background.color=0x88cc5500
    else
      sketchybar --set $NAME background.color=0x22f0f0f0
    fi
fi
