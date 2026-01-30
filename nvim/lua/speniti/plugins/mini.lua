return {
	"echasnovski/mini.nvim",
	version = "*",
	config = function()
		require("mini.ai").setup({ n_lines = 500 })

		local animate = require("mini.animate")
		local scroll_timer = vim.uv.new_timer()

		animate.setup()

		local function smooth_mouse_scroll(cmd)
			animate.config.scroll.enable = false

			local feed = vim.api.nvim_replace_termcodes(cmd, true, false, true)
			vim.api.nvim_feedkeys(feed, "n", false)

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

				animate.config.scroll.enable = true
			end)
		end

		require("mini.files").setup()

		require("mini.diff").setup({ view = { style = "sign" } })
		require("mini.git").setup()

		require("mini.indentscope").setup()

		require("mini.starter").setup({
			header = table.concat({
				[[                                                                       ]],
				[[                                                                     ]],
				[[       ████ ██████           █████      ██                     ]],
				[[      ███████████             █████                             ]],
				[[      █████████ ███████████████████ ███   ███████████   ]],
				[[     █████████  ███    █████████████ █████ ██████████████   ]],
				[[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
				[[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
				[[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
				[[                                                                       ]],
			}, "\n"),
		})

		require("mini.statusline").setup()
		require("mini.surround").setup()

		vim.keymap.set("n", "\\", "<cmd>lua MiniFiles.open()<CR>", { desc = "Open Mini file explorer" })

		vim.keymap.set({ "n", "v", "i" }, "<ScrollWheelUp>", function()
			smooth_mouse_scroll("<C-y>")
		end)
		vim.keymap.set({ "n", "v", "i" }, "<ScrollWheelDown>", function()
			smooth_mouse_scroll("<C-e>")
		end)
	end,
}
