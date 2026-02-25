-- Smooth mouse scroll for mini.animate
-- Temporarily disables scroll animations during mouse wheel scrolling,
-- then re-enables them after a short delay.

local scroll_timer

--- Temporarily toggle mini.animate scroll animation
--- Disables scroll animations and schedules a timer to re-enable them after 200ms.
--- If a timer already exists, it is stopped and restarted.
local function toggle_animate_temporarily()
	MiniAnimate.config.scroll.enable = false

	if not scroll_timer or scroll_timer:is_closing() then
		scroll_timer = vim.uv.new_timer()
	end

	if not scroll_timer then
		vim.notify("Failed to create scroll timer for mouse smoothing", vim.log.levels.ERROR)
		return
	end

	if scroll_timer:is_active() then
		scroll_timer:stop()
	end

	scroll_timer:start(200, 0, function()
		scroll_timer:close()
		MiniAnimate.config.scroll.enable = true
	end)
end

--- Execute a smooth scroll command
--- Temporarily disables mini.animate scroll animations (if available),
--- then executes the given scroll command.
---
--- @param cmd string The scroll command to execute (e.g., "<C-y>" for scroll up, "<C-e>" for scroll down)
local function smooth_scroll(cmd)
	if MiniAnimate then
		toggle_animate_temporarily()
	end

	local feed = vim.api.nvim_replace_termcodes(cmd, true, false, true)
	vim.api.nvim_feedkeys(feed, "n", false)
end

-- Keymaps for mouse wheel scrolling in normal, visual, and insert modes
vim.keymap.set({ "n", "v", "i" }, "<ScrollWheelUp>", function()
	smooth_scroll("<C-y>")
end)
vim.keymap.set({ "n", "v", "i" }, "<ScrollWheelDown>", function()
	smooth_scroll("<C-e>")
end)
