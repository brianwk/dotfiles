#!/bin/bash

num_containers=0

if colima status native > /dev/null; then 
  num_containers=$(docker info -f json | jq '.ContainersRunning')
  sketchybar --set docker icon.drawing=on label.drawing=on
else
  sketchybar --set docker icon.drawing=off
fi

sketchybar --set docker label="$num_containers"
