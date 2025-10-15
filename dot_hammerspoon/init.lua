local reloadTimer

local SKETCHYBAR_PATH = "/opt/homebrew/bin/sketchybar"

function getSketchyBarSpaces()
    -- sketchybar --query bar | jq '.items' | grep 'space.' | awk -F'"' '{print $4}'
    local handle = io.popen(SKETCHYBAR_PATH .. " --query bar | jq '.items' | grep '\"space.' | awk -F'\"' '{print $2}'")
    local result = handle:read("*a")
    handle:close()
    local spaces = {}
    for space in string.gmatch(result, "space%.%S+") do
        table.insert(spaces, space)
    end
    return spaces
end

function getSketchyBarSpaceDisplay(space)
    -- need to get first key in bounding_rects to get display number
    -- value will be like "display-1" or "display-2"
    -- sketchybar --query space | jq '.bounding_rects'
    local handle = io.popen(SKETCHYBAR_PATH .. " --query " .. space .. " | jq '.bounding_rects | to_entries[0].key'")
    local result = handle:read("*a")
    handle:close()
    -- Return the display number without "display-" prefix
    -- strip leading / trailing quotes
    return result:gsub("display%-", ""):gsub("[%s\"]+", "")
end

function reloadSketchyBar()
    -- Get a table of all active screens
    local allScreens = hs.screen.allScreens()

    -- Get the number of screens
    local numberOfDisplays = #allScreens
    local spaces = getSketchyBarSpaces()
    print("Number of displays: " .. numberOfDisplays)
    print("Spaces: " .. table.concat(spaces, ", "))
    -- Loop through the spaces and get the display for each
    -- If the display number is greater than the number of screens, then set the space to be on display 1
    for i, space in ipairs(spaces) do
        local display = getSketchyBarSpaceDisplay(space)
        print("Space: " .. space .. " is on display: " .. display)
        local displayNumber = tonumber(display)
        if numberOfDisplays == 1 or i <= 4 then
            print("Moving " .. space .. " from display " .. displayNumber .. " to display 1")
            hs.execute(SKETCHYBAR_PATH .. " --set " .. space .. " display=1", true)
        elseif numberOfDisplays > 1 and displayNumber == 1 and i > 4 then
            print("Moving " .. space .. " from display " .. displayNumber .. " to display 2")
            hs.execute(SKETCHYBAR_PATH .. " --set " .. space .. " display=2", true)
        else
            print(space .. " is on display " .. tostring(displayNumber) .. " which is valid")
        end
    end
end

hs.hotkey.bind({"alt"}, "c", reloadSketchyBar)

function runOnUnlock(eventType)
    if (eventType == hs.caffeinate.watcher.screensDidUnlock) then
        hs.timer.doAfter(30, reloadSketchyBar)
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
