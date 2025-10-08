function runOnUnlock(eventType)
    if (eventType == hs.caffeinate.watcher.screensDidUnlock) then
        hs.execute("sleep 3 && /opt/homebrew/bin/sketchybar --reload", true) 
    end
end

local lockWatcher = hs.caffeinate.watcher.new(runOnUnlock)
lockWatcher:start()

function screenLayoutChangedCallback()
    hs.execute("sleep 3 && /opt/homebrew/bin/sketchybar --reload", true)
end

-- Create a screen watcher object
local screenWatcher = hs.screen.watcher.new(screenLayoutChangedCallback)

-- Start the screen watcher
screenWatcher:start()
