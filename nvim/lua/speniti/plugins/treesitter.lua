return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local parsers = {
				"angular",
				"bash",
				"blade",
				"comment",
				"css",
				"diff",
				"dockerfile",
				"git_config",
				"git_rebase",
				"gitattributes",
				"gitcommit",
				"gitignore",
				"go",
				"html",
				"http",
				"ini",
				"javascript",
				"json",
				"lua",
				"make",
				"markdown",
				"markdown_inline",
				"passwd",
				"phpdoc",
				"php",
				"php_only",
				"regex",
				"sql",
				"typescript",
				"vim",
				"xml",
				"yaml",
			}

			require("nvim-treesitter").install(parsers)

			local pattern = {}
			for _, parser in ipairs(parsers) do
				local pp = vim.treesitter.language.get_filetypes(parser)
				pattern = vim.tbl_extend("force", parsers, pp)
			end

			vim.api.nvim_create_autocmd("FileType", {
				pattern = pattern,
				callback = function()
					vim.treesitter.start()
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter", branch = "main" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				include_surrounding_whitespace = false,
				lookahead = true,
				move = { set_jumps = true },
				selection_modes = {
					["@function.outer"] = "V",
					["@class.outer"] = "V",
				},
			})

			local select = require("nvim-treesitter-textobjects.select")
			local swap = require("nvim-treesitter-textobjects.swap")
			local move = require("nvim-treesitter-textobjects.move")

			vim.keymap.set({ "x", "o" }, "af", function()
				select.select_textobject("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "if", function()
				select.select_textobject("@function.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ac", function()
				select.select_textobject("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ic", function()
				select.select_textobject("@class.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "as", function()
				select.select_textobject("@local.scope", "locals")
			end)

			vim.keymap.set("n", "<leader>a", function()
				swap.swap_next("@parameter.inner")
			end)
			vim.keymap.set("n", "<leader>A", function()
				swap.swap_previous("@parameter.outer")
			end)

			vim.keymap.set({ "n", "x", "o" }, "]m", function()
				move.goto_next_start("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[m", function()
				move.goto_previous_start("@function.outer", "textobjects")
			end)

			local ts_repeat = require("nvim-treesitter-textobjects.repeatable_move")

			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat.repeat_last_move_next)
			vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat.repeat_last_move_previous)
			vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat.builtin_f_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat.builtin_F_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat.builtin_t_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat.builtin_T_expr, { expr = true })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter", branch = "main" },
		config = function()
			require("treesitter-context").setup()
		end,
	},
}
