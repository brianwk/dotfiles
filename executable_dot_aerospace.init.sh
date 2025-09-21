#!/bin/sh
killall AutoRaise
/Applications/AutoRaise.app/Contents/MacOS/AutoRaise 2>&1 > /dev/null &
killall AerospaceSwipe
/Users/briankaplan/.local/share/aerospace-swipe/AerospaceSwipe.app/Contents/MacOS/AerospaceSwipe 2>&1 > /dev/null &
