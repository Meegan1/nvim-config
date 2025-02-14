return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts_extend = { "ensure_installed" },
		opts = {
			-- Treesitter plugins to ensure are installed
			ensure_installed = {
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
			},
		},
		---@param opts TSConfig
		config = function(_, opts)
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

			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			parser_config.blade = {
				install_info = {
					url = "https://github.com/EmranMR/tree-sitter-blade",
					files = { "src/parser.c" },
					branch = "main",
				},
				filetype = "blade",
			}

			require("nvim-treesitter.configs").setup(opts)
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
