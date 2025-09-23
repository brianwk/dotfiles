#!/bin/sh
borders active_color=0xcccc5500 inactive_color=0x66f0f0f0 width=8.0 style=square 2>&1 > /dev/null &
killall AutoRaise
/Applications/AutoRaise.app/Contents/MacOS/AutoRaise 2>&1 > /dev/null &
killall AerospaceSwipe
/Users/briankaplan/.local/share/aerospace-swipe/AerospaceSwipe.app/Contents/MacOS/AerospaceSwipe 2>&1 > /dev/null &
