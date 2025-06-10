return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		"nvim-tree/nvim-web-devicons",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		require("telescope").setup({
			defaults = {
				path_display = { "smart" },
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.75,
					},
				},
			},
			pickers = {
				buffers = {
					theme = "dropdown",
					previewer = false,
					attach_mappings = function(prompt_bufnr, map)
						map("i", "<C-d>", function()
							local actions = require("telescope.actions")
							local state = require("telescope.actions.state")

							local picker = state.get_current_picker(prompt_bufnr)
							local multi_selections = picker:get_multi_selection()

							if next(multi_selections) == nil then
								vim.api.nvim_buf_delete(state.get_selected_entry().bufnr, { force = true })
							else
								for _, selection in ipairs(multi_selections) do
									vim.api.nvim_buf_delete(selection.bufnr, { force = true })
								end
							end

							actions.close(prompt_bufnr)
							require("telescope.builtin").buffers()
						end)

						return true
					end,
				},
				diagnostics = {
					theme = "ivy",
				},
				keymaps = {
					theme = "dropdown",
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Fuzzy find opened buffers" })
		vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Fuzzy find in diagnostics" })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Fuzzy find help tags" })
		vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Fuzzy find keymaps" })
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy find files in CWD" })
		vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Fuzzy find string under cursor in CWD" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Fuzzy find string in CWD" })
		vim.keymap.set("n", "<leader>f.", builtin.oldfiles, { desc = "Fuzzy find in recent files" })
	end,
}
