#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

# Function to add a workspace if it doesn't exist
add_workspace_if_missing() {
    local sid="$1"
    local monitor="$2"
    
    # Check if workspace already exists
    if ! sketchybar --query space.$sid >/dev/null 2>&1; then
        # Label is sid which if it contains more than a number it should strip out the number in front
        if [[ "$sid" =~ ^[0-9]+$ ]]; then
            label="$sid"
        else
            # Strip only leading digits
            icon="$(echo "$sid" | sed -E 's/^[0-9]+//')"
            # label should be the numbers from above
            label="$(echo "$sid" | sed -E 's/[^0-9]+//g')"
        fi
        # Set background based on focused item, focused background should be 0x88cc5500
        if [ "$(aerospace list-workspaces --focused)" = "$sid" ]; then
            background=0x88cc5500
        else
            background=0x22f0f0f0
        fi
        echo "Adding new workspace $sid with label $label on monitor $monitor"
        sketchybar --add item space.$sid left \
            --subscribe space.$sid aerospace_workspace_change display_change system_woke \
            --set space.$sid \
            display=$(( monitor == 1 ? 2 : 1 )) \
            background.color="$background" \
            background.corner_radius=5 \
            background.height=20 \
            label.font.family="Hack Nerd Font" \
            label.font.size=8 \
            label.color=0xccf0f0f0 \
            icon.padding_left=4 \
            icon.padding_right=0 \
            icon="$icon" \
            label="$label" \
            label.y_offset=-6 \
            label.padding_left=4 \
            label.padding_right=4 \
            click_script="aerospace workspace $sid" \
            script="$CONFIG_DIR/plugins/aerospace.sh $sid"
    fi
}

# Function to remove workspace items that no longer exist
remove_missing_workspaces() {
    # Get all current workspace items from sketchybar
    existing_items=$(sketchybar --query bar 2>/dev/null | grep -o '"space\.[^"]*"' | sed 's/"//g' | sed 's/space\.//g' || echo "")
    
    # Get all current aerospace workspaces
    current_workspaces=""
    for monitor in $(aerospace list-monitors | awk '{print $1}'); do
        for sid in $(aerospace list-workspaces --monitor "$monitor" 2>/dev/null); do
            current_workspaces="$current_workspaces $sid"
        done
    done
    
    # Remove workspaces that no longer exist in aerospace
    for item in $existing_items; do
        if [[ ! " $current_workspaces " =~ " $item " ]]; then
            echo "Removing workspace $item (no longer exists in aerospace)"
            sketchybar --remove space.$item 2>/dev/null || true
        fi
    done
}

# Sync all workspaces (add any missing ones and remove deleted ones)
remove_missing_workspaces

for monitor in $(aerospace list-monitors | awk '{print $1}'); do
    for sid in $(aerospace list-workspaces --monitor "$monitor"); do
        add_workspace_if_missing "$sid" "$monitor"
    done
done

# If a specific workspace was passed as argument, handle its visibility
if [ -n "$1" ]; then
    workspace_id="$1"
    is_visible=false
    
    for monitor in $(aerospace list-monitors | awk '{print $1}'); do
      visible_workspace=$(aerospace list-workspaces --monitor "$monitor" --visible)
      if [ "$workspace_id" = "$visible_workspace" ]; then
        is_visible=true
        break
      fi
    done
    
    # Set background based on visibility
    if [ "$is_visible" = true ]; then
        sketchybar --set $NAME background.color=0x88cc5500
    else
        sketchybar --set $NAME background.color=0x22f0f0f0
    fi
fi
