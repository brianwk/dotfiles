#!/bin/zsh
# 
#❯ zellij --session architary --layout ~/.config/zellij/architary.kdl
#There is no active session!

NAME=$1
zellij attach -cf $NAME options --default-layout $NAME
