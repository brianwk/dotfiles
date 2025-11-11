-- This is a HammerSpoon configuration that enhances my AeroSpace and SketchyBar integration:
-- 1. Watches for screen unlock events and screen layout changes.
-- 2. On such events, it reloads SketchyBar configuration to ensure spaces are
--    correctly assigned to displays based on the number of active screens.
--    It also reorders Visual Studio Code windows to specific workspaces based on their profile.
-- 3. Monitors Visual Studio Code windows and moves them to specific workspaces
--    based on the project name in the window title.
-- I made this script to bandaid issues with multi-monitor setups with AeroSpace and SketchyBar.

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
    -- How to sort by var space
    table.sort(spaces, function(a, b)
        local numA = tonumber(a:match("space%.(%d+)"))
        local numB = tonumber(b:match("space%.(%d+)"))
        return numA < numB
    end)
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
        if numberOfDisplays == 1 then
            print("Moving " .. space .. " from display " .. displayNumber .. " to display 1")
            hs.execute(SKETCHYBAR_PATH .. " --set " .. space .. " display=1", true)
        elseif displayNumber == 1 and i <= 4 then
            print("Moving " .. space .. " from display " .. displayNumber .. " to display 2")
            hs.execute(SKETCHYBAR_PATH .. " --set " .. space .. " display=2", true)
        elseif displayNumber == 2 and i > 4 then
            print("Moving " .. space .. " from display " .. displayNumber .. " to display 1")
            hs.execute(SKETCHYBAR_PATH .. " --set " .. space .. " display=1", true)
        else
            print(space .. " is on display " .. tostring(displayNumber) .. " which is valid")
        end
    end
    hs.execute(SKETCHYBAR_PATH .. " --reorder " .. table.concat(spaces, " "), true)

    reorderCodeWindows()
end

function runOnUnlock(eventType)
    print("Caffeinate event: " .. tostring(eventType))
    if (eventType == hs.caffeinate.watcher.screensDidUnlock) then
        -- print("Screen unlocked, reloading SketchyBar in 5s")
        reloadTimer = hs.timer.doAfter(5, reorderCodeWindows)
    end
end

lockWatcher = hs.caffeinate.watcher.new(runOnUnlock)
lockWatcher:start()

function screenLayoutChangedCallback()
    if reloadTimer and reloadTimer:running() then
        print("Stopping previous timer")
	reloadTimer:stop()
    end
    -- print("Reloading SketchyBar in 5s")
    reloadTimer = hs.timer.doAfter(5, reorderCodeWindows)
end

-- Create a screen watcher object
screenWatcher = hs.screen.watcher.newWithActiveScreen(screenLayoutChangedCallback)
-- Start the screen watcher
screenWatcher:start()


codeFilter = hs.window.filter.new{'Code - Insiders', 'Code'}

local workspaceMap = {
    ["DEFAULT"] = "3󱃖",
    ["Pulse Report"] = "4",
    ["Architary"] = "5",
    ["CRC"] = "6󰳶",
    ["BGA"] = "7󰘸",
    ["SD"] = "8"
}

function reorderCodeWindows()
    local codeWindows = codeFilter:getWindows()
    for _, window in ipairs(codeWindows) do
        -- run the callback titleChangedCallback logic once to ensure correct workspace
        titleChangedCallback(window, nil, nil)
    end
end

-- Define the callback function to run when a title changes.
function titleChangedCallback(window, appName, event)
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
        wmMoveToWorkspace(window, newWorkspace)
    else
        wmMoveToWorkspace(window, "8")
    end
end

function wmMoveToWorkspace(window, workspace)
  local workspaceIdx = workspace:match("^(%d+)") or workspace
  local cmd = string.format(
    "rift-cli execute workspace move-window %s %s",
    workspaceIdx,
    window:id()
  )

  print("CMD:", cmd)
  local ok, stdout, exitType, rc = hs.execute(cmd, true)
  stdout = type(stdout) == "string" and stdout or ""
  if ok then
    print(string.format(
      "Success: (%s / %s) -> %s",
      exitType,
      rc,
      stdout:gsub("%s+$", "")
    ))
  else
    print(string.format(
      "Failure: (%s / %s) -> %s",
      exitType,
      rc,
      stdout:gsub("%s+$", "")
    ))
  end
end

--function wmMoveToWorkspace(window, workspace)
    -- Get workspace with just leading digits
--    local workspaceIdx = workspace:match("^(%d+)")
--    print("Moving window: " .. window:title() .. " to workspace: " .. workspace .. " (idx: " .. workspaceIdx .. ")")
--    print("CMD: rift-cli execute workspace move-window " .. workspaceIdx .. " " .. window:id() .. " &")
--    os.execute("rift-cli execute workspace move-window " .. workspaceIdx .. " " .. window:id() .. " &")
    -- os.execute("aerospace move-node-to-workspace --window-id " .. window:id() .. " " .. workspace .. " &")
--end

-- Subscribe the filter to the 'titleChanged' event.
-- The filter will now begin monitoring for this event.
codeFilter:subscribe(hs.window.filter.windowTitleChanged, titleChangedCallback)
