--- @alias frame {x:number, y:number, w:number, h:number}

--- Border between windows in px.
local border = 16

--- It calculates a percentage of the screen size.
---@param screen hs.screen
---@param percent number
---@param limit {w:number, h:number}?
---@param cell {w:number, h:number}?
---@param padding number?|{top:number, left:number, bottom:number?, right:number?}?
---@return hs.geometry
local function screenPercent(screen, percent, limit, cell, padding)
	local frame = screen:frame()
	limit = limit or { w = frame.w, h = frame.h }

	local w = math.min(frame.w * percent, limit.w)
	local h = math.min(frame.h * percent, limit.h)

	if cell then
		local pw = w
		local ph = h

		if type(padding) == "number" then
			pw = w - padding
			ph = h - padding
		elseif padding ~= nil then
			pw = w - padding.left - (padding.right or 0)
			ph = h - padding.top - (padding.bottom or 0)
		end

		w = w - pw % cell.w
		h = h - ph % cell.h
	end

	return { x = (frame.w - w) / 2, y = frame.y + (frame.h - h) / 2, w = w, h = h }
end

--- It calculates a portions of the frame size.
---@param portion frame
---@param frame frame
---@param cell {w:number, h:number}?
---@param padding number?|{top:number, left:number, bottom:number?, right:number?}?
---@return hs.geometry
local function screenPortion(portion, frame, cell, padding)
	local geometry = {
		x = frame.x + (portion.x > 0 and border / 2 or border) + (frame.w * portion.x),
		y = frame.y + (portion.y > 0 and border / 2 or border) + (frame.h * portion.y),
		w = frame.w * portion.w - (portion.w < 1 and border * 1.5 or border * 2),
		h = frame.h * portion.h - (portion.h < 1 and border * 1.5 or border * 2),
	}

	if cell then
		local w = geometry.w
		local h = geometry.h

		if type(padding) == "number" then
			w = w - padding
			h = h - padding
		elseif padding ~= nil then
			w = w - padding.left - (padding.right or 0)
			h = h - padding.top - (padding.bottom or 0)
		end

		geometry.w = geometry.w - w % cell.w
		geometry.h = geometry.h - h % cell.h

		geometry.x = frame.x + (frame.w - geometry.w) / 2
		geometry.y = frame.y + (frame.h - geometry.h) / 2
	end

	return geometry
end

---@class Layouts
local M = {
	screen = hs.screen.primaryScreen(),
	frame = hs.screen.primaryScreen():frame(),
	config = {},
}

---@param screen hs.screen?
---@return Layouts
function M.new(screen)
	local self = setmetatable({}, M)
	self.screen = screen or hs.screen.primaryScreen()
	self.frame = self.screen:frame()

	return self
end

function M:config(config)
	self.config = config
end

--- It maximizes the window to almost fit the size of the screen.
---@param cell {w:number, h:number}?
---@param padding number?|{top:nnumber, left:number, bottom:number?, right:number?}?
---@return hs.geometry
function M:almostMaximized(cell, padding)
	return screenPercent(self.screen, self.screen:fullFrame().w > 1920 and 0.9 or 0.95, nil, cell, padding)
end

--- It resizes the window to 60% of the screen (max 1024x900 px).
---@param cell {w:number, h:number}?
---@param padding number?|{top:nnumber, left:number, bottom:number?, right:number?}?
---@return hs.geometry
function M:reasonableSize(cell, padding)
	return screenPercent(self.screen, 0.6, { w = 1024, h = 900 }, cell, padding)
end

--- It resizes the window to fit the two thirds of the screen frame.
---@param frame frame?
---@param cell {w:number, h:number}?
---@param padding number?|{top:nnumber, left:number, bottom:number?, right:number?}?
---@return hs.geometry
function M:twoThirds(frame, cell, padding)
	return screenPortion({ x = 1 / 6, y = 0, w = 2 / 3, h = 1 }, frame or self.frame, cell, padding)
end

--- It resizes the window to fit the left half of the screen frame.
---@param frame frame?
---@param cell {w:number, h:number}?
---@param padding number?|{top:nnumber, left:number, bottom:number?, right:number?}?
---@return hs.geometry
function M:leftHalf(frame, cell, padding)
	return screenPortion({ x = 0, y = 0, w = 1 / 2, h = 1 }, frame or self.frame, cell, padding)
end

--- It resizes the window to fit the left two thirds of the screen frame.
---@param frame frame?
---@param cell {w:number, h:number}?
---@param padding number?|{top:nnumber, left:number, bottom:number?, right:number?}?
---@return hs.geometry
function M:leftTwoThirds(frame, cell, padding)
	return screenPortion({ x = 0, y = 0, w = 2 / 3, h = 1 }, frame or self.frame, cell, padding)
end

--- It resizes the window to fit the right half of the screen frame.
---@param frame frame?
---@param cell {w:number, h:number}?
---@param padding number?|{top:nnumber, left:number, bottom:number?, right:number?}?
---@return hs.geometry
function M:rightHalf(frame, cell, padding)
	return screenPortion({ x = 1 / 2, y = 0, w = 1 / 2, h = 1 }, frame or self.frame, cell, padding)
end

--- It resizes the window to fit the right one third of the screen frame.
---@param frame frame?
---@param cell {w:number, h:number}?
---@param padding number?|{top:nnumber, left:number, bottom:number?, right:number?}?
---@return hs.geometry
function M:rightOneThird(frame, cell, padding)
	return screenPortion({ x = 2 / 3, y = 0, w = 1 / 3, h = 1 }, frame or self.frame, cell, padding)
end

function M.__index(_, key)
	return M[key]
end

return M
