return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	main = "nvim-treesitter.configs",
	dependencies = {
		{
			"JoosepAlviste/nvim-ts-context-commentstring",
			opts = {
				languages = { php_only = "// %s", php = "// %s" },
				custom_calculation = function(_, language_tree)
					if vim.bo.filetype == "blade" then
						if language_tree._lang == "html" then
							return "{{-- %s --}}"
						else
							return "// %s"
						end
					end
				end,
			},
		},
	},
	opts = {
		ensure_installed = {
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
			"passwd",
			"phpdoc",
			"php",
			"php_only",
			"regex",
			"rust",
			"sql",
			"typescript",
			"vim",
			"vue",
			"xml",
			"yaml",
		},
		auto_install = true,
		highlight = { enable = true, additional_vim_regex_highlighting = { "ruby" } },
		indent = { enable = true, disable = { "ruby", "yaml" } },
		rainbow = { enable = true },
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["if"] = "@function.inner",
					["af"] = "@function.outer",
					["ia"] = "@parameter.inner",
					["aa"] = "@parameter.outer",
				},
			},
		},
	},
	config = function(_, opts)
		local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

		parser_config.blade = {
			install_info = {
				url = "https://github.com/EmranMR/tree-sitter-blade",
				files = { "src/parser.c" },
				branch = "main",
			},
			filetype = "blade",
		}

		vim.filetype.add({ pattern = { [".*%.blade%.php"] = "blade" } })

		require("nvim-treesitter.configs").setup(opts)
	end,
}
