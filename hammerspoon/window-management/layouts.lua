--- @alias frame {x:number, y:number, w:number, h:number}

--- Border between windows in px.
local border = 16

--- It calculates a percentage of the screen size.
---@param screen hs.screen
---@param percent number
---@param limit {w:number, h:number}?
---@return hs.geometry
local function screenPercent(screen, percent, limit)
	local frame = screen:frame()
	limit = limit or { w = frame.w, h = frame.h }

	local w = math.min(frame.w * percent, limit.w)
	local h = math.min(frame.h * percent, limit.h)

	return { x = (frame.w - w) / 2, y = frame.y + (frame.h - h) / 2, w = w, h = h }
end

--- It calculates a portions of the frame size.
---@param portion frame
---@param frame frame
---@return hs.geometry
local function screenPortion(portion, frame)
	return {
		x = frame.x + (portion.x > 0 and border / 2 or border) + (frame.w * portion.x),
		y = frame.y + (portion.y > 0 and border / 2 or border) + (frame.h * portion.y),
		w = frame.w * portion.w - (portion.w < 1 and border * 1.5 or border * 2),
		h = frame.h * portion.h - (portion.h < 1 and border * 1.5 or border * 2),
	}
end

---@class Layouts
local M = {
	screen = hs.screen.primaryScreen(),
	frame = hs.screen.primaryScreen():frame(),
}

---@param screen hs.screen?
---@return Layouts
function M.new(screen)
	local self = setmetatable({}, M)
	self.screen = screen or hs.screen.primaryScreen()
	self.frame = self.screen:frame()

	return self
end

--- It maximizes the window to almost fit the size of the screen.
---@return hs.geometry
function M:almostMaximized()
	return screenPercent(self.screen, self.screen:fullFrame().w > 1920 and 0.9 or 0.95)
end

--- It resizes the window to 60% of the screen (max 1024x900 px).
---@return hs.geometry
function M:reasonableSize()
	return screenPercent(self.screen, 0.6, { w = 1024, h = 900 })
end

--- It resizes the window to fit the two thirds of the screen frame.
---@param frame frame?
---@return hs.geometry
function M:twoThirds(frame)
	return screenPortion({ x = 1 / 6, y = 0, w = 2 / 3, h = 1 }, frame or self.frame)
end

--- It resizes the window to fit the left half of the screen frame.
---@param frame frame?
---@return hs.geometry
function M:leftHalf(frame)
	return screenPortion({ x = 0, y = 0, w = 1 / 2, h = 1 }, frame or self.frame)
end

--- It resizes the window to fit the left two thirds of the screen frame.
---@param frame frame?
---@return hs.geometry
function M:leftTwoThirds(frame)
	return screenPortion({ x = 0, y = 0, w = 2 / 3, h = 1 }, frame or self.frame)
end

--- It resizes the window to fit the right half of the screen frame.
---@param frame frame?
---@return hs.geometry
function M:rightHalf(frame)
	return screenPortion({ x = 1 / 2, y = 0, w = 1 / 2, h = 1 }, frame or self.frame)
end

--- It resizes the window to fit the right one third of the screen frame.
---@param frame frame?
---@return hs.geometry
function M:rightOneThird(frame)
	return screenPortion({ x = 2 / 3, y = 0, w = 1 / 3, h = 1 }, frame or self.frame)
end

function M.__index(_, key)
	return M[key]
end

return M
