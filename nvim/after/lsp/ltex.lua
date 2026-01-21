return {
	filetypes = { "go", "javascript", "lua", "markdown", "php", "rust", "typescript" },
	settings = {
		ltex = {
			enabled = { "go", "javascript", "lua", "markdown", "php", "rust", "typescript" },
			language = "en-US",
			diagnosticSeverity = "information",
			additionalRules = { enalblePickyRules = true },
			server = { url = "https://api.languagetool.org/v2" },
		},
	},
}
