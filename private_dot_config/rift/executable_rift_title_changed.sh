#!/bin/zsh

RIFT_CLI="/Users/briankaplan/dev-current/rift/target/debug/rift-cli"

#{"type":"window_title_changed","window_id":{"pid":87483,"idx":49327},"workspace_id":{"idx":10,"version":1},"workspace_index":9,"workspace_name":"9","previous_title":"Visual Studio Code","new_title":"CreatePulseButton.tsx — PulseReport — Pulse Report","space_id":4,"display_uuid":"37D8832A-2D66-02CA-B9F7-8F30A301B230"}

TARGET_WINDOW_TITLES=( "zellij" "wezterm" )
JSON_INPUT="$@"

WINDOW_ID=$(echo $RIFT_EVENT_JSON | jq -r '.window_id.idx')
WORKSPACE_ID=$RIFT_WORKSPACE_ID #$(echo $JSON_INPUT | jq -r '.workspace_index')
PREVIOUS_TITLE=$RIFT_PREVIOUS_WINDOW_TITLE #$(echo $JSON_INPUT | jq -r '.previous_title')
NEW_TITLE=$RIFT_WINDOW_TITLE #$(echo $JSON_INPUT | jq -r '.new_title')
DISPLAY_UUID=$RIFT_DISPLAY_UUID #$(echo $JSON_INPUT | jq -r '.display_uuid')

echo $RIFT_EVENT_JSON >> /Users/briankaplan/rift_title_changed.log

if [[ ${TARGET_WINDOW_TITLES[(Ie)$PREVIOUS_TITLE]} == 0 ]]; then
  echo "Ignoring window with previous title: " $PREVIOUS_TITLE >> /Users/briankaplan/rift_title_changed.log
  exit 2
fi

WORK_DISPLAY_UUID="35D8FFE8-6A4B-45DF-BB20-14D3D229A5B8"

typeset -A profile_map=( PulseReport 4 architary 5 )
VSCODE_PROFILE=$(echo $NEW_TITLE | ggrep -oP -- '^(\w+)')
NEW_WORKSPACE=$profile_map[$VSCODE_PROFILE]
if [[ -z "$NEW_WORKSPACE" ]]; then
  exit 0
fi
echo "Moving $WINDOW_ID to $NEW_WORKSPACE" >> /Users/briankaplan/rift_title_changed.log

if [[ -z "$NEW_WORKSPACE" ]]; then
  exit 2
fi

$RIFT_CLI execute workspace move-window $NEW_WORKSPACE $WINDOW_ID
#$RIFT_CLI execute workspace switch $NEW_WORKSPACE

exit 0 
