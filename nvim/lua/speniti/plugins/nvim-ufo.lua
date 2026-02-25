return {
	"kevinhwang91/nvim-ufo",
	dependencies = "kevinhwang91/promise-async",
	config = function()
		vim.opt.foldcolumn = "1"
		vim.opt.foldlevel = 99
		vim.opt.foldlevelstart = 99
		vim.opt.foldenable = true

		local ufo = require("ufo")

		ufo.setup({
			provider_selector = function(_, _, _)
				return { "lsp", "indent" }
			end,
		})

		-- vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
		-- vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Change all folds" })
	end,
}
