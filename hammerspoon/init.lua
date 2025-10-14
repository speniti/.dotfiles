require("applications")

hs.alert.defaultStyle = {
	strokeWidth = 0,
	strokeColor = { white = 1, alpha = 0 },
	fillColor = { white = 0, alpha = 0.6 },
	textColor = { white = 1, alpha = 1 },
	textFont = ".AppleSystemUIFont",
	textSize = 20,
	radius = 8,
	atScreenEdge = 0,
	fadeInDuration = 0.15,
	fadeOutDuration = 0.15,
	padding = nil,
}

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "r", hs.reload)

local DAS_KEYBOARD_ID = "320_9456"

hs.keycodes.setLayout("Italian")

for _, device in ipairs(hs.usb.attachedDevices()) do
	local deviceID = device.productID .. "_" .. device.vendorID

	if deviceID == DAS_KEYBOARD_ID then
		hs.keycodes.setLayout("British – PC")
	end
end

hs.alert("Config re-loaded.")
