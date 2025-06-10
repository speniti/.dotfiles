return {
	"https://gitlab.com/gitlab-org/editor-extensions/gitlab.vim.git",
	event = { "BufReadPre", "BufNewFile" },
	ft = { "blade", "css", "go", "html", "javascript", "lua", "php", "rust", "typescript" },
	cond = function()
		return vim.env.GITLAB_TOKEN ~= nil and vim.env.GITLAB_TOKEN ~= ""
	end,
	config = function()
		require("gitlab").setup({
			statusline = { enabled = true },
			code_suggestions = {
				auto_filetypes = { "blade", "css", "go", "html", "javascript", "lua", "php", "rust", "typescript" },
				ghost_text = {
					enabled = true,
					toggle_enabled = "<C-h>",
					accept_suggestion = "<C-l>",
					clear_suggestions = "<C-k>",
					stream = true,
				},
			},
		})

		vim.keymap.set("n", "<C-g>", "<Plug>(GitLabToggleCodeSuggestions)")
		vim.o.completeopt = "menu,menuone"
	end,
}
