return {
	settings = {
		json = {
			schemas = {
				{ fileMatch = { "composer.json" }, url = "https://getcomposer.org/schema.json" },
				{
					fileMatch = { ".luarc", ".luarc.json" },
					url = "https://json.schemastore.org/luaurc.json",
				},
				{ fileMatch = { "package.json" }, url = "https://json.schemastore.org/package.json" },
				{
					fileMatch = { "tsconfig.json", "jsconfig.json" },
					url = "https://json.schemastore.org/tsconfig.json",
				},
				{
					fileMatch = { "*.prettierrc", ".prettierrc" },
					url = "https://json.schemastore.org/prettierrc.json",
				},
			},
		},
	},
}
