hs.window.animationDuration = 0

local layouts = require("window-management/layouts").new()

hs.hotkey.bind({ "ctrl", "alt" }, "r", function()
	hs.window.focusedWindow():setFrame(layouts:reasonableSize())
end)

hs.hotkey.bind({ "ctrl", "alt" }, "return", function()
	hs.window.focusedWindow():setFrame(layouts:almostMaximized())
end)

hs.hotkey.bind({ "ctrl", "alt" }, "h", function()
	hs.window.focusedWindow():setFrame(layouts:leftHalf(layouts:almostMaximized()))
end)

hs.hotkey.bind({ "ctrl", "alt" }, "l", function()
	hs.window.focusedWindow():setFrame(layouts:rightHalf(layouts:almostMaximized()))
end)

hs.hotkey.bind({ "ctrl", "alt" }, "t", function()
	hs.window.focusedWindow():setFrame(layouts:twoThirds(layouts:almostMaximized()))
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

hs.hotkey.bind({ "alt", "ctrl", "shift" }, "w", function()
	local screen = hs.screen.primaryScreen()

	local almostMaximized = layouts:almostMaximized()
	local reasonableSize = layouts:reasonableSize()

	hs.layout.apply({
		{ "Zen", nil, screen, nil, nil, almostMaximized },
		{ "kitty", nil, screen, nil, nil, almostMaximized },
		{ "GoLand", nil, screen, nil, nil, almostMaximized },
		{ "PhpStorm", nil, screen, nil, nil, almostMaximized },
		{ nil, "Welcome to GoLand", screen, nil, nil, reasonableSize },
		{ nil, "Welcome to PhpStorm", screen, nil, nil, reasonableSize },
		{ "slack", nil, screen, nil, nil, reasonableSize },
	})
end)

return layouts
