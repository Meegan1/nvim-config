return {
	{
		"luckasRanarison/tailwind-tools.nvim",
		name = "tailwind-tools",
		build = ":UpdateRemotePlugins",
		branch = "master",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"neovim/nvim-lspconfig",
		},
		enabled = false,
		opts = {
			server = {
				settings = {
					settings = {
						experimental = {
							classRegex = {
								"\\/\\*\\s*tw\\s*\\*\\/\\s*[`'\"](.*)[`'\"];?",
								{ "(?:twMerge|twJoin)\\(([^\\);]*)[\\);]", "[`'\"]([^'\"`,;]*)[`'\"]" },
								"twc\\`(.*)\\`;?",
								{ "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
								{ "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
							},
						},
					},
				},
			},
		},
		config = function(_, opts)
			require("tailwind-tools").setup(opts)
		end,
	},
}
