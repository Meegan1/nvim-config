return {
	{
		"nvim-telescope/telescope.nvim",
		opts = function()
			return {
				defaults = {
					mappings = {
						n = {
							["l"] = require("telescope.actions").select_default,
							["<D-.>"] = require("telescope.actions").select_default,
						},
					},
				},
			}
		end,
		config = function(_, opts)
			require("telescope").setup(opts)

			vim.keymap.set({ "n", "i", "v" }, "<D-p>", function()
				require("telescope.builtin").find_files()
			end)

			vim.keymap.set({ "n", "i", "v" }, "<D-P>", function()
				require("telescope.builtin").commands()
			end)

			vim.keymap.set("n", "<D-F>", function()
				require("telescope.builtin").live_grep()
			end)

			vim.keymap.set("n", "<D-t>", function()
				require("telescope.builtin").lsp_workspace_symbols()
			end)
		end,
	},
	{
		"debugloop/telescope-undo.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope.nvim",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
		},
		opts = {
			extensions = {
				undo = {},
			},
		},
		config = function(_, opts)
			require("telescope").setup(opts)
			require("telescope").load_extension("undo")

			vim.keymap.set("n", "<leader>u", function()
				require("telescope").extensions.undo.undo({
					initial_mode = "normal",
					mappings = {
						n = {
							["l"] = require("telescope-undo.actions").restore,
						},
					},
				})
			end, {
				desc = "undo history",
			})
		end,
	},
}
