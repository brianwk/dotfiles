codeFilter = hs.window.filter.new{'Code - Insiders', 'Code'}
wezTermFilter = hs.window.filter.new{'WezTerm'}

local workspaceMap = {
    ["DEFAULT"] = "3󱃖",
    ["Pulse Report"] = "4",
    ["Architary"] = "5",
    ["CRC"] = "6󰳶",
    ["BGA"] = "7󰘸",
    ["SD"] = "8",
    ["INSIDERS"] = "8",
    ["Rust"] = "8"
}

function windowCreatedCallback(window, appName, event)
    local targetScreen = hs.screen.find(WORK_DISPLAY_UUID)
    local windowScreen = window:screen()
    wmMoveToDisplay(window, targetScreen)
    -- if appName == "WezTerm" then
    --    wmMoveToWorkspace(window, "9")
    -- end
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
    windowCreatedCallback(window, appName, event)
    if projectName and workspaceMap[projectName] then
        local newWorkspace = workspaceMap[projectName]
        wmMoveToWorkspace(window, newWorkspace)
    else
        wmMoveToWorkspace(window, "8")
    end
end

function wmMoveToDisplay(win, nextScreen)
  if not nextScreen then
    -- No other screen to move to
    return
  end

  local currentScreen = win:screen()

  if nextScreen:getUUID() == currentScreen:getUUID() then
    return
  end

  local winFrame = win:frame()
  local nextScreenFrame = nextScreen:frame()

  -- Calculate new position: move the window to the right edge of the next screen
  local newX = nextScreenFrame.x + (nextScreenFrame.w - winFrame.w) / 2
  local newY = nextScreenFrame.y + (nextScreenFrame.h - winFrame.h) / 2

  -- Ensure the new coordinates are within the bounds of the new screen
  newX = math.max(nextScreenFrame.x, newX)
  newY = math.max(nextScreenFrame.y, newY)

  -- Set the window's new frame
  win:setFrame({x = newX, y = newY, w = 1, h = 1})
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
codeFilter:subscribe(hs.window.filter.windowCreated, windowCreatedCallback)
codeFilter:subscribe(hs.window.filter.windowTitleChanged, titleChangedCallback)
wezTermFilter:subscribe(hs.window.filter.windowCreated, windowCreatedCallback)
