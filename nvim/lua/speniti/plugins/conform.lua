return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				css = { "prettier" },
				lua = { "stylua" },
				html = { "prettier" },
				json = { "prettier" },
				javascript = { "prettier" },
				markdown = { "prettier" },
				typescript = { "prettier" },
				yaml = { "prettier" },
			},
			format_on_save = {
				async = false,
				lsp_fallback = true,
			},
			notify_no_formatters = false,
		})

		vim.keymap.set({ "n", "v" }, "<leader>cf", function()
			conform.format({
				async = false,
				lsp_fallback = true,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
