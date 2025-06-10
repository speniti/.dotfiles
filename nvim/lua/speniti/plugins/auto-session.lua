return {
	"rmagatti/auto-session",
	enabled = false,
	config = function()
		require("auto-session").setup({
			auto_restore_enabled = false,
			auto_session_suppress_dirs = { "~", "~/Code", "~/Downloads", "~/Documents", "~/Desktop" },
		})

		vim.keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })
		vim.keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" })
	end,
}
