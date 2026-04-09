vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		require("speniti.core.ui.scroll").setup()
	end,
})
