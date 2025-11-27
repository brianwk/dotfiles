#!/bin/bash

num_outdated=$(brew outdated -q | wc -l | tr -d ' \n')
sketchybar --set homebrew drawing=on icon.font.size=24 label.drawing=on icon.drawing=on label.font="Hack Nerd Font" label="$num_outdated"
