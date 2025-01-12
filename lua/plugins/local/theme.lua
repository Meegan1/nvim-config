return {
	{
		"catppuccin/nvim",
		opts = {},
		priority = 1000, -- Ensure it loads first
		config = function()
			require("catppuccin").setup({
				integrations = {
					blink_cmp = true,
					mason = true,
					telescope = true,
					gitsigns = true,
					treesitter = true,
					noice = true,
					nvim_surround = true,
					neotree = true,
					barbar = true,
					indent_blankline = {
						enabled = true,
						scope_color = "surface1",
					},
					flash = true,
					which_key = true,
					neogit = true,
					dadbod_ui = true,
				},
			})

			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
