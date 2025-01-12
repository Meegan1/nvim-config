return {
	{
		"tpope/vim-dadbod",
	},
	{ -- optional saghen/blink.cmp completion source
		"saghen/blink.cmp",
		opts = {
			sources = {
				-- add vim-dadbod-completion to your completion providers
				default = { "lsp", "path", "snippets", "buffer", "dadbod" },
				providers = {
					dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
				},
			},
		},
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			-- Your DBUI configuration
			vim.g.db_ui_use_nerd_fonts = 1
			vim.keymap.set("n", "<leader>db", function()
				vim.cmd("DBUIToggle")
			end, { noremap = true, silent = true, desc = "Toggle DBUI" })
		end,
	},
}
