return {
	"nvim-lua/plenary.nvim",
	"christoomey/vim-tmux-navigator",
	{ "ThePrimeagen/vim-be-good", cmd = "VimBeGood" },
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
}
