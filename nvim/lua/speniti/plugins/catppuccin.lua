return {
	"catppuccin/nvim",
	enabled = false,
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			backgroud = {
				light = "latte",
				dark = "frappe",
			},
			styles = {
				comments = { "italic" },
			},
			integrations = {
				gitsigns = true,
				mason = true,
				markdown = true,
				mini = true,
				native_lsp = {
					enabled = true,
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
					},
				},
				neotree = true,
				telescope = true,
				treesitter = true,
				treesitter_context = true,
				which_key = true,
			},
		})

		vim.cmd.colorscheme("catppuccin")
	end,
}
