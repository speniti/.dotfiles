return {
	"echasnovski/mini.nvim",
	version = "*",
	config = function()
		require("mini.ai").setup({ n_lines = 500 })
		require("mini.animate").setup({ cursor = { enable = false } })

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

		require("mini.statusline").setup({ use_icons = true })
		require("mini.surround").setup()

		vim.keymap.set("n", "\\", "<cmd>lua MiniFiles.open()<CR>", { desc = "Open Mini file explorer" })
	end,
}
