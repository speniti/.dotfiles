return {
	"nvim-mini/mini.nvim",
	version = "*",
	config = function()
		require("mini.ai").setup({ n_lines = 500 })
		require("mini.animate").setup()
		require("mini.diff").setup({ view = { style = "sign" } })
		require("mini.extra").setup()
		require("mini.files").setup()
		require("mini.git").setup()
		require("mini.icons").setup()
		require("mini.indentscope").setup()

		require("mini.notify").setup({
			window = {
				config = function()
					return {
						anchor = "SE",
						width = math.floor(0.3 * vim.o.columns),
						col = vim.o.columns,
						row = vim.o.lines - 1,
					}
				end,
			},
		})

		require("mini.pairs").setup()
		require("mini.pick").setup()
		require("mini.splitjoin").setup()

		require("mini.starter").setup({
			header = table.concat({
				[[                                                                       ]],
				[[                                                                     ]],
				[[       ████ ██████           █████      ██                     ]],
				[[      ███████████             █████                             ]],
				[[      █████████ ███████████████████ ███   ███████████   ]],
				[[     █████████  ███    █████████████ █████ ██████████████   ]],
				[[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
				[[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
				[[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
				[[                                                                       ]],
			}, "\n"),
		})

		require("mini.statusline").setup()
		require("mini.surround").setup()

		vim.keymap.set("n", "\\", MiniFiles.open, { desc = "Open Mini file explorer" })

		local pick = {
			center = function(w, h)
				return function()
					local height = math.floor((h or w or 0.4) * vim.o.lines)
					local width = math.floor((w or 0.4) * vim.o.columns)

					return {
						anchor = "NW",
						height = height,
						width = width,
						row = math.floor(0.5 * (vim.o.lines - height)),
						col = math.floor(0.5 * (vim.o.columns - width)),
					}
				end
			end,
			bottom = function(h, w)
				return function()
					local height = math.floor((h or 0.3) * vim.o.lines)

					return { anchor = "SW", height = height, width = math.floor((w or 1) * vim.o.columns) }
				end
			end,
		}

		vim.keymap.set("n", "<leader>fb", function()
			MiniPick.builtin.buffers(nil, {
				mappings = {
					wipeout = {
						char = "<C-d>",
						func = function()
							vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {})
						end,
					},
				},
				window = { config = pick.center() },
			})
		end, { desc = "Open Mini buffers picker" })

		vim.keymap.set("n", "<leader>fc", function()
			MiniExtra.pickers.commands(nil, { window = { config = pick.bottom(0.3, 0.3) } })
		end, { desc = "Open Mini commands picker" })

		vim.keymap.set("n", "<leader>fd", function()
			MiniExtra.pickers.diagnostic({ scope = "current" }, {
				mappings = {
					change_scope = {
						char = "<C-o>",
						func = function()
							MiniPick.stop()
							MiniExtra.pickers.diagnostic(nil, { window = { config = pick.bottom } })
						end,
					},
				},
				window = { config = pick.bottom() },
			})
		end, { desc = "Open Mini diagnostic picker" })

		vim.keymap.set("n", "<leader>ff", function()
			MiniPick.builtin.files(nil, {
				window = { config = pick.center(0.6) },
			})
		end, { desc = "Open Mini files picker" })

		vim.keymap.set("n", "<leader>fg", function()
			MiniPick.builtin.grep_live(nil, {
				window = { config = pick.bottom() },
			})
		end, { desc = "Open Mini live grep picker" })

		vim.keymap.set("n", "<leader>fh", function()
			MiniPick.builtin.help(nil, {
				window = { config = pick.bottom() },
			})
		end, { desc = "Open Mini help picker" })
	end,
}
