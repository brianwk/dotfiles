local reloadTimer

function reloadSketchyBar()
    hs.execute("/opt/homebrew/bin/sketchybar --reload", true)
end

function runOnUnlock(eventType)
    if (eventType == hs.caffeinate.watcher.screensDidUnlock) then
        hs.timer.delayed.new(30, reloadSketchyBar)
    end
end

local lockWatcher = hs.caffeinate.watcher.new(runOnUnlock)
lockWatcher:start()

function screenLayoutChangedCallback()
    if reloadTimer and reloadTimer:running() then
        print("Stopping previous timer")
	reloadTimer:stop()
    end
    print("Reloading SketchyBar in 3s")
    reloadTimer = hs.timer.doAfter(3, reloadSketchyBar)
end

-- Create a screen watcher object
local activeScreenWatcher = hs.screen.watcher.newWithActiveScreen(screenLayoutChangedCallback)
local screenWatcher = hs.screen.watcher.new(screenLayoutChangedCallback)
-- Start the screen watcher
activeScreenWatcher:start()
screenWatcher:start()


local wf = hs.window.filter
local codeFilter = wf.new('Code')

local workspaceMap = {
    ["DEFAULT"] = "3󱃖",
    ["Pulse Report"] = "4",
    ["Architary"] = "5",
    ["CRC"] = "6󰳶",
    ["BGA"] = "7󰘸",
    ["Lavish Rides"] = "8󱥴"
}

-- Define the callback function to run when a title changes.
local function titleChangedCallback(window, appName, event)
    local newTitle = window:title()
    local sep = "—"
    -- Split the title by sep and then get the last part
    -- If sep isn't in title then projectName should be newTitle 
    local projectName = nil
    if string.find(newTitle, sep) then
        local parts = {}
        for part in string.gmatch(newTitle, "([^" .. sep .. "]+)") do
            table.insert(parts, part)
        end
        projectName = parts[#parts]:gsub("^%s*(.-)%s*$", "%1") -- Trim whitespace
    else
        projectName = newTitle:gsub("^%s*(.-)%s*$", "%1") -- Trim whitespace
    end
    if projectName and workspaceMap[projectName] then
        local newWorkspace = workspaceMap[projectName]
        hs.execute("aerospace move-node-to-workspace --window-id " .. window:id() .. " " .. newWorkspace, true)
    end
end

-- Subscribe the filter to the 'titleChanged' event.
-- The filter will now begin monitoring for this event.
codeFilter:subscribe(wf.windowTitleChanged, titleChangedCallback)
