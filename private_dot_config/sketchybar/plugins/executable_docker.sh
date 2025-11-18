#!/bin/bash

num_containers=0
colima status native 2> /dev/null
exit_code=$?
if [ "$exit_code" -eq 0 ]; then 
  num_containers=$(docker info -f json | jq '.ContainersRunning')
  sketchybar --set docker icon.drawing=on label.drawing=on
else
  sketchybar --set docker icon.drawing=off
fi

sketchybar --set docker label="$num_containers"
