#!/bin/zsh
# set var workspace which is the argument sent to the script
#aerospace enable off
#aerospace enable on
local workspace=$1
aerospace move-node-to-workspace $workspace 2>&1 >/dev/null
#aerospace workspace $workspace 2>&1 >/dev/null
