return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		opts = {},
		---@param opts TSConfig
		config = function(_, opts)
			require("nvim-treesitter").setup(opts)

			-- Treesitter plugins to ensure are installed
			require("nvim-treesitter").install({
				"typescript",
				"javascript",
				"tsx",
				"html",
				"lua",
				"json",
				"yaml",
				"css",
				"scss",
				"graphql",
				"bash",
				"liquid",
				"vue",
				"markdown",
				"markdown_inline",
				"regex",
				"gotmpl",
				"helm",
				"php",
				"diff",
				"nix",
				"blade",
				"twig",
				"astro",
			})

			-- Add support for gotmpl filetype and helm templates
			vim.filetype.add({
				extension = {
					gotmpl = "gotmpl",
				},
				pattern = {
					[".*/templates/.*%.tpl"] = "helm",
					[".*/templates/.*%.ya?ml"] = "helm",
					["helmfile.*%.ya?ml"] = "helm",
				},
			})

			-- Add support for the blade filetype
			vim.filetype.add({
				extension = {
					blade = "blade",
				},
				pattern = {
					["%.blade%.php"] = "blade",
				},
			})
		end,
	},
	{
		dir = vim.fn.stdpath("config") .. "/plugins/nvim-ts-autotag",
		name = "nvim-ts-autotag",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {},
		config = function(_, opts)
			require("nvim-ts-autotag").setup(opts)
		end,
	},
}
