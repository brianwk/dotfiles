#!/bin/zsh
# 
#❯ zellij --session architary --layout ~/.config/zellij/architary.kdl
#There is no active session!

NAME=$1
zellij --session $NAME --layout $NAME 2>1
if [[ $? == 1 ]] then
  zellij --session $NAME --new-session-with-layout $NAME;
fi

if [[ $? == 1 ]] then
  zellij attach $NAME;
fi
