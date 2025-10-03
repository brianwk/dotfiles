#!/bin/sh
borders active_color=0xcccc5500 inactive_color=0x66f0f0f0 width=8.0 hidpi=on style=square 2>&1 > /dev/null &
killall AutoRaise
/Applications/AutoRaise.app/Contents/MacOS/AutoRaise 2>&1 > /dev/null &
