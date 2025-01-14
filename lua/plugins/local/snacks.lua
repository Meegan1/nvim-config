return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			bigfile = { enabled = true },
			notifier = {
				enabled = true,

				top_down = false,
			},

			indent = {
				enabled = true,
				indent = {
					char = "▎",
				},

				scope = {
					char = "▎",
				},

				animate = {
					enabled = false,
				},
			},
		},
		config = function(_, config)
			require("snacks").setup(config)
			local C = require("catppuccin.palettes").get_palette()

			-- create command Notifications to show the notifications
			vim.api.nvim_create_user_command("Notifications", function()
				require("snacks").notifier.show_history()
			end, {
				desc = "Show notifications",
			})

			vim.api.nvim_set_hl(0, "SnacksIndent", { fg = C.surface0 })
			vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#3b4261" })
		end,
	},
}
