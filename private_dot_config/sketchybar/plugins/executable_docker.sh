#!/bin/bash

num_containers=0
colima status 2> /dev/null
exit_code=$?
if [ "$exit_code" -eq 0 ]; then 
  disk_usage=$(colima ssh -- df -h /dev/root --output=pcent|ggrep -oP '\d+')
  num_containers=$(docker info -f json | jq '.ContainersRunning')
  sketchybar --set docker icon.drawing=on label.drawing=on
else
  sketchybar --set docker icon.drawing=off
fi

sketchybar --set docker label.font="Hack Nerd Font" label="󱣘 $num_containers  $disk_usage%"
