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

hs.screen.watcher.newWithActiveScreen(hs.reload):start()
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "r", hs.reload)

hs.alert("Config re-loaded.")
