return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		require("mason").setup({
			ui = { height = 0.9 },
		})

		vim.diagnostic.config({
			severity_sort = true,
			float = { border = "rounded", source = "if_many" },
			underline = { severity = vim.diagnostic.severity.ERROR },
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅚 ",
					[vim.diagnostic.severity.WARN] = "󰀪 ",
					[vim.diagnostic.severity.INFO] = "󰋽 ",
					[vim.diagnostic.severity.HINT] = "󰌶 ",
				},
			},
			virtual_text = {
				source = "if_many",
				spacing = 2,
				format = function(diagnostic)
					local diagnostic_message = {
						[vim.diagnostic.severity.ERROR] = diagnostic.message,
						[vim.diagnostic.severity.WARN] = diagnostic.message,
						[vim.diagnostic.severity.INFO] = diagnostic.message,
						[vim.diagnostic.severity.HINT] = diagnostic.message,
					}

					return diagnostic_message[diagnostic.severity]
				end,
			},
		})

		vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

		local servers = {
			"bashls",
			"cssls",
			"dockerls",
			"docker_compose_language_service",
			"emmet_language_server",
			"eslint",
			"gh_actions_ls",
			"jsonls",
			"lua_ls",
			"stylelint_lsp",
			"ts_ls",
		}

		require("mason-tool-installer").setup({
			ensure_installed = vim.list_extend(servers, { "stylua" }),
		})

		require("mason-lspconfig").setup({
			ensure_installed = {},
			automatic_enable = true,
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				local client = vim.lsp.get_client_by_id(event.data.client_id)

				if not client then
					return
				end

				if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
					local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
						--- @diagnostic disable-next-line: redefined-local
						callback = function(event)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event.buf })
						end,
					})
				end

				if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})
	end,
}
