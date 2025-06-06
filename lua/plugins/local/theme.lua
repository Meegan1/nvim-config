return {
	{
		"catppuccin/nvim",
		opts = {},
		priority = 1000, -- Ensure it loads first
		config = function()
			require("catppuccin").setup({
				integrations = {
					blink_cmp = true,
					dap = true,
					dap_ui = true,
					mason = true,
					gitsigns = true,
					treesitter = true,
					noice = true,
					nvim_surround = true,
					neotree = true,
					barbar = true,
					flash = true,
					which_key = true,
					neogit = true,
					dadbod_ui = true,
					notify = true,
					mini = true,
					snacks = true,
					fzf = true,
				},
			})

			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
