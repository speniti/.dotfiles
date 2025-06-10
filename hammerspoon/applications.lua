local layouts = require("window-management")

hs.application.enableSpotlightForNameSearches(true)

local hyper = { "cmd", "alt", "ctrl", "shift" }

--- It launches or focuses an application, setting the specified dimensions
--- and position or hides it if it is the front-most application.
---@param name string
---@param frame frame
---@return hs.application|nil
local function launchOrFocusOrHide(name, frame)
	local application = hs.application.frontmostApplication()
	if application:name() == name or application:bundleID() == name then
		local _ = application:hide() or application:selectMenuItem("Hide " .. application:name())

		return application
	end

	application = hs.application.open(name, 3, true)
	application:focusedWindow():setFrame(frame)

	return application
end

--- It launches or focuses and I.D.E. (eg. PhpStorm, GoLand, etc.), setting
--- the specified dimensions ad position or hides it if it is the
--- afront-mos tpplication.
---@param name string
---@return hs.application
local function launchFocusOrHideIDE(name)
	local application = hs.application.frontmostApplication()
	if application:name() == name then
		local _ = application:hide() or application:selectMenuItem("Hide " .. name)

		return application
	end

	application = hs.application.open(name, 3, true)

	if application:focusedWindow():title():match("^Welcome to") then
		application:focusedWindow():setFrame(layouts:reasonableSize()):centerOnScreen()
	else
		application:focusedWindow():setFrame(layouts:almostMaximized())
	end

	return application
end

hs.hotkey.bind(hyper, "b", function()
	launchOrFocusOrHide("Zen", layouts:almostMaximized())
end)

hs.hotkey.bind(hyper, "c", function()
	launchOrFocusOrHide("com.microsoft.VSCode", layouts:almostMaximized())
end)

hs.hotkey.bind(hyper, "f", function()
	launchOrFocusOrHide("Finder", layouts:reasonableSize())
end)

hs.hotkey.bind(hyper, "g", function()
	launchFocusOrHideIDE("GoLand")
end)

hs.hotkey.bind(hyper, "m", function()
	launchOrFocusOrHide("Mail", layouts:twoThirds(layouts:almostMaximized()))
end)

hs.hotkey.bind(hyper, "p", function()
	launchFocusOrHideIDE("PhpStorm")
end)

hs.hotkey.bind(hyper, "s", function()
	launchOrFocusOrHide("Slack", layouts:reasonableSize())
end)

hs.hotkey.bind(hyper, "t", function()
	launchOrFocusOrHide("kitty", layouts:almostMaximized())
end)
