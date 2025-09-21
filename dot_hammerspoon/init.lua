function runOnUnlock(eventType)
    if (eventType == hs.caffeinate.watcher.screensDidUnlock) then
        -- Replace with the path to your shell script or command
        hs.execute("sleep 3 && /opt/homebrew/bin/sketchybar --reload", true) 
    end
end

local lockWatcher = hs.caffeinate.watcher.new(runOnUnlock)
lockWatcher:start()
