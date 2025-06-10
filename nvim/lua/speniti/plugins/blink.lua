return {
		'saghen/blink.cmp',
		event = 'VimEnter',
		version = '1.*',
		dependencies = {
			{
				'L3MON4D3/LuaSnip',
				version = '2.*',
				build = (function() return 'make install_jsregexp' end)(),
				dependencies = {
					{ 'rafamadriz/friendly-snippets', config = function() require('luasnip.loaders.from_vscode').lazy_load() end, },
				},
				opts = {},
			},
			'folke/lazydev.nvim',
		},
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			keymap = { preset = 'enter' },
			completion = {
				documentation = { auto_show = false, auto_show_delay_ms = 500 },
				ghost_text = { enabled = true },
			},
			cmdline = {
				completion = {
					ghost_text = { enabled = true }
				}
			},
			sources = {
				default = { 'lsp', 'path', 'snippets', 'lazydev' },
				providers = {
					lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
				},
			},
			snippets = { preset = 'luasnip' },
			fuzzy = { implementation = 'lua' },
			signature = { enabled = true },
		},
	}
