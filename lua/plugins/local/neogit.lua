return {
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",

			"nvim-telescope/telescope.nvim",
		},
		opts = {
			disable_insert_on_commit = true,
			graph_style = "unicode",
			process_spinner = false,
		},
		config = function(_, config)
			local neogit = require("neogit")
			neogit.setup(config)
		end,
	},
}
