hs.window.animationDuration = 0

local layouts = require("window-management/layouts").new()

local function terminalConfig()
	local app = hs.window.focusedWindow():application()

	return TERMINALS[app:name()] or TERMINALS[app:bundleID()] or {}
end

hs.hotkey.bind({ "ctrl", "alt" }, "r", function()
	local config = terminalConfig()

	hs.window.focusedWindow():setFrame(layouts:reasonableSize(config.cell, config.padding))
end)

hs.hotkey.bind({ "ctrl", "alt" }, "return", function()
	local config = terminalConfig()

	hs.window.focusedWindow():setFrame(layouts:almostMaximized(config.cell, config.padding))
end)

hs.hotkey.bind({ "ctrl", "alt" }, "h", function()
	hs.window.focusedWindow():setFrame(layouts:leftHalf(layouts:almostMaximized()))
end)

hs.hotkey.bind({ "ctrl", "alt" }, "l", function()
	hs.window.focusedWindow():setFrame(layouts:rightHalf(layouts:almostMaximized()))
end)

hs.hotkey.bind({ "ctrl", "alt" }, "t", function()
	local config = terminalConfig()

	hs.window.focusedWindow():setFrame(layouts:twoThirds(layouts:almostMaximized(), config.cell, config.padding))
end)

hs.hotkey.bind({ "ctrl", "alt" }, "c", function()
	hs.window.focusedWindow():centerOnScreen()
end)

hs.hotkey.bind({ "ctrl", "alt", "cmd" }, "h", function()
	hs.window.focusedWindow():setFrame(layouts:leftTwoThirds(layouts:almostMaximized()))
end)

hs.hotkey.bind({ "ctrl", "alt", "shift" }, "l", function()
	hs.window.focusedWindow():setFrame(layouts:rightOneThird(layouts:almostMaximized()))
end)

-- hs.hotkey.bind({ "ctrl", "alt" }, "", function() end)

return layouts
