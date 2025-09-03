return {
	"mfussenegger/nvim-lint",
	events = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			css = { "stylelint" },
			php = { "phpstan" },
			javascript = { "eslint" },
			typescript = { "eslint" },
		}

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
			group = vim.api.nvim_create_augroup("lint", { clear = true }),
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
