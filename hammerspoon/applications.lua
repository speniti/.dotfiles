TERMINALS = {
	["com.mitchellh.ghostty"] = {
		cell = { w = 11, h = 36 },
		padding = 32,
	},
}

local layouts = require("window-management")

hs.application.enableSpotlightForNameSearches(true)

local hyper = { "cmd", "alt", "ctrl", "shift" }

--- It launches or focuses an application, setting the specified dimensions
--- and position or hides it if is the front-most application.
---@param name string
---@param frame frame
---@param hideOthers boolean|nil
---@return hs.application|nil
local function launchOrFocusOrHide(name, frame, hideOthers, watcher)
	local application = hs.application.frontmostApplication()
	if application:name() == name or application:bundleID() == name then
		local _ = application:hide() or application:selectMenuItem("Hide " .. application:name())

		return application
	end

	local mustResize = false

	if watcher == nil then
		watcher = hs.application.watcher.new(function(appName, eventType, app)
			local isTheOne = appName == name or app:bundleID() == name

			if eventType == hs.application.watcher.launching and isTheOne then
				mustResize = true
			end

			if eventType == hs.application.watcher.launched and isTheOne then
				hs.timer.doAfter(0.3, function()
					app:focusedWindow():setFrame(frame)
				end)

				watcher:stop()
			end

			if eventType == hs.application.watcher.activated and isTheOne then
				if mustResize then
					app:focusedWindow():setFrame(frame)
				end

				if hideOthers then
					hs.eventtap.keyStroke({ "cmd", "alt" }, "h", 200000, app)
				end

				watcher:stop()
			end
		end)
	end

	watcher:start()

	local running = hs.application.get(name)

	if running then
		running:activate()

		return running
	end

	return hs.application.open(name, 3, true)
end

--- It launches or focuses and I.D.E. (eg. PhpStorm, GoLand, etc.)
---@param name string
---@return hs.application|nil
local function launchFocusOrHideIDE(name)
	local watcher

	watcher = hs.application.watcher.new(function(appName, eventType, app)
		local isTheOne = appName == name or app:bundleID() == name

		if eventType == hs.application.watcher.launched and isTheOne then
			hs.timer.doAfter(0.3, function()
				if app:focusedWindow():title():match("^Welcome to") then
					app:focusedWindow():setFrame(layouts:reasonableSize()):centerOnScreen()
				else
					app:focusedWindow():setFrame(layouts:almostMaximized())
				end
			end)

			watcher:stop()
		end

		if eventType == hs.application.watcher.activated and isTheOne then
			hs.eventtap.keyStroke({ "cmd", "alt" }, "h", 200000, app)

			watcher:stop()
		end
	end)

	return launchOrFocusOrHide(name, {}, true, watcher)
end

hs.hotkey.bind(hyper, "b", function()
	launchOrFocusOrHide("com.brave.Browser", layouts:almostMaximized())
end)

local C = hs.hotkey.modal.new(hyper, "c")

C:bind(hyper, "a", function()
	launchOrFocusOrHide("com.apple.iCal", layouts:reasonableSize())
	C:exit()
end)

C:bind(hyper, "o", function()
	launchOrFocusOrHide("com.microsoft.VSCode", layouts:almostMaximized())
	C:exit()
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
	local bundleID = "com.mitchellh.ghostty"

	launchOrFocusOrHide(
		bundleID,
		layouts:twoThirds(layouts:almostMaximized(), TERMINALS[bundleID].cell, TERMINALS[bundleID].padding)
	)
end)

hs.hotkey.bind(hyper, "z", function()
	launchOrFocusOrHide("app.zen-browser.zen", layouts:almostMaximized())
end)
