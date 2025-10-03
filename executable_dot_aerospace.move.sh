#!/bin/bash

sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE

#builtin_monitor=$(aerospace list-monitors|grep Built-in|awk '{printf $1}')

# Get the ID of the current (focused) workspace
#current_workspace=$(aerospace list-workspaces --monitor $builtin_monitor)

# Find all PiP windows and move them to the current workspace
# It searches for both "Picture-in-Picture" and "Picture in Picture" in window titles
#aerospace list-windows --all | grep -E "(Picture-in-Picture|Picture in Picture)" | awk '{print $1}' | while read window_id; do
#  if [ -n "$window_id" ]; then
#    aerospace move-node-to-workspace --window-id "$window_id" "$current_workspace"
#  fi
#done
