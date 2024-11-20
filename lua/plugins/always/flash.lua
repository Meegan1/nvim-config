local useSmartCase = function(callback)
	local ignorecase = vim.go.ignorecase
	local smartcase = vim.go.smartcase

	vim.go.ignorecase = true
	vim.go.smartcase = true

	callback()

	vim.go.ignorecase = ignorecase
	vim.go.smartcase = smartcase
end

return {
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		config = function(_, opts)
			require("flash").setup(opts)
		end,
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					useSmartCase(function()
						require("flash").jump()
					end)
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					useSmartCase(function()
						require("flash").remote()
					end)
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},
}
