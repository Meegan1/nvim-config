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
			image = {},
		},
		config = function(_, config)
			require("snacks").setup(config)
			local C = require("catppuccin.palettes").get_palette()

			vim.api.nvim_set_hl(0, "SnacksIndent", { fg = C.surface0 })
			vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#3b4261" })

			-- create command Notifications to show the notifications
			vim.api.nvim_create_user_command("Notifications", function()
				require("snacks").notifier.show_history()
			end, {
				desc = "Show notifications",
			})

			-- create command BufferDelete to delete the current buffer
			vim.api.nvim_create_user_command("BufferDelete", function()
				require("snacks").bufdelete.delete()

				require("snacks").notifier.notify("Buffer deleted", "info")
			end, {
				desc = "Delete current buffer",
			})

			-- create command BufferDeleteAll to delete all buffers
			vim.api.nvim_create_user_command("BufferDeleteAll", function()
				require("snacks").bufdelete.all()

				require("snacks").notifier.notify("All buffers deleted", "info")
			end, {
				desc = "Delete all buffers",
			})

			-- create command BufferDeleteOther to delete all buffers except the current one
			vim.api.nvim_create_user_command("BufferDeleteOther", function()
				require("snacks").bufdelete.other()

				require("snacks").notifier.notify("All other buffers deleted", "info")
			end, {
				desc = "Delete all buffers except the current one",
			})

			vim.keymap.set({ "n", "v" }, "<leader>dd", function()
				vim.cmd("BufferDelete")
			end, { noremap = true, desc = "Delete Buffer" })

			vim.keymap.set({ "n", "v" }, "<leader>dD", function()
				vim.cmd("BufferDeleteAll")
			end, { noremap = true, desc = "Delete all buffers" })

			vim.keymap.set({ "n", "v" }, "<leader><leader>dd", function()
				vim.cmd("BufferDeleteOther")
			end, { noremap = true, desc = "Delete all buffers except the current one" })
		end,
	},
}
