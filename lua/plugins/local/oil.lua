return {
	{
		"stevearc/oil.nvim",
		opts = {
			view_options = {
				show_hidden = true,
				is_always_hidden = function(name, bufnr)
					if name == ".." then
						return true
					end

					return false
				end,
			},
		},
		config = true,
		keys = {
			-- Open the current file's directory in Oil
			{
				"-",
				function()
					require("oil").open()
				end,
				desc = "Open Oil",
			},
			-- Open the current working directory in Oil
			{
				"_",
				function()
					require("oil").open(vim.fn.getcwd())
				end,
			},
		},
	},
}
