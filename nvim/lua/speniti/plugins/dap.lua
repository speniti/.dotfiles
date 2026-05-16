return {
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")
			local widgets = require("dap.ui.widgets")

			dap.adapters.php = {
				type = "executable",
				command = "node",
				args = {
					vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js",
				},
			}

			dap.configurations.php = {
				{
					name = "Listen for Xdebug (host network)",
					type = "php",
					request = "launch",
					port = 9003,
					pathMappings = {
						["/app/"] = "${workspaceFolder}",
					},
				},
				{
					name = "Listen for Xdebug (bridge network)",
					type = "php",
					request = "launch",
					port = 9003,
					hostname = "0.0.0.0",
					pathMappings = {
						["/app/"] = "${workspaceFolder}",
					},
				},
			}

			vim.fn.sign_define("DapBreakpoint", { text = "󰝥", texthl = "DapBreakpoint", numhl = "DapBreakpoint" })
			vim.fn.sign_define("DapBreakpointCondition", {
				text = "󰟃",
				texthl = "DapBreakpointCondition",
				numhl = "DapBreakpointCondition",
			})
			vim.fn.sign_define("DapLogPoint", { text = "󰟃", texthl = "DapLogPoint", numhl = "DapLogPoint" })
			vim.fn.sign_define("DapStopped", { text = "󰉉", texthl = "DapStopped", numhl = "DapStopped" })

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "php",
				callback = function()
					vim.opt_local.iskeyword:append("$")
				end,
			})

			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle breakpoint" })
			vim.keymap.set("n", "<leader>dB", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "DAP: Conditional breakpoint" })
			vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP: Continue" })
			vim.keymap.set("n", "<leader>dC", dap.run_to_cursor, { desc = "DAP: Run to cursor" })
			vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "DAP: Step into" })
			vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "DAP: Step over" })
			vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "DAP: Step out" })
			vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "DAP: Terminate" })
			vim.keymap.set({ "n", "v" }, "<leader>de", function()
				widgets.hover()
			end, { desc = "DAP: Evaluate expression" })
			vim.keymap.set("n", "<leader>dE", dap.repl.toggle, { desc = "DAP: Toggle REPL" })
		end,
	},
	{
		"igorlfs/nvim-dap-view",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("dap-view").setup({
				auto_toggle = true,
				winbar = {
					default_section = "scopes",
					controls = {
						enabled = true,
					},
				},
				windows = {
					size = 0.33,
					position = "right",
					terminal = {
						hide = { "php" },
					},
				},
				switchbuf = "usevisible,usetab,newtab",
			})

			vim.keymap.set("n", "<leader>dv", function()
				require("dap-view").open()
			end, { desc = "DAP: Open view" })
			vim.keymap.set("n", "<leader>dV", function()
				require("dap-view").close()
			end, { desc = "DAP: Close view" })
		end,
	},
}
