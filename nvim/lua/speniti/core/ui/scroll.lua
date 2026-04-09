local M = {}

local scroll_timer

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

local function smooth_scroll(cmd)
	if MiniAnimate then
		toggle_animate_temporarily()
	end

	local feed = vim.api.nvim_replace_termcodes(cmd, true, false, true)
	vim.api.nvim_feedkeys(feed, "n", false)
end

function M.setup()
	vim.keymap.set({ "n", "v", "i" }, "<ScrollWheelUp>", function()
		smooth_scroll("<C-y>")
	end)
	vim.keymap.set({ "n", "v", "i" }, "<ScrollWheelDown>", function()
		smooth_scroll("<C-e>")
	end)
end

return M
