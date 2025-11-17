#!/bin/bash

if colima status native > /dev/null; then 
  sketchybar --set docker icon.drawing=on
else
  sketchybar --set docker icon.drawing=off
fi
