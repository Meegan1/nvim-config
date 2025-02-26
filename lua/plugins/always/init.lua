return {
	{ "tpope/vim-repeat" },
	{
		"echasnovski/mini.ai",
		config = true,
	},
	{
		"kana/vim-textobj-entire",
		dependencies = {
			"kana/vim-textobj-user",
		},
	},
	{
		"kana/vim-textobj-line",
		dependencies = {
			"kana/vim-textobj-user",
		},
	},
	{
		"bkad/CamelCaseMotion",
	},
	{
		"tpope/vim-abolish",
	},
	{
		"andrewradev/splitjoin.vim",
	},
	{
		"echasnovski/mini.move",
		opts = {
			mappings = {
				left = "<A-h>",
				down = "<A-j>",
				up = "<A-k>",
				right = "<A-l>",

				line_left = "<A-h>",
				line_down = "<A-j>",
				line_up = "<A-k>",
				line_right = "<A-l>",
			},
		},
	},
}
