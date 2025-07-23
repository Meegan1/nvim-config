return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",

			-- Fixes issues with vitests not running in zsh
			-- https://github.com/marilari88/neotest-vitest/pull/58
			-- https://github.com/marilari88/neotest-vitest/issues/66
			{ "phallguy/neotest-vitest", branch = "phallguy/escape-from-zsh" },
		},

		opts = function()
			return {
				adapters = {
					require("neotest-vitest"),
				},
			}
		end,
		config = function(_, opts)
			require("neotest").setup(opts)

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "neotest-summary",
				callback = function()
					vim.keymap.set("n", "q", function()
						require("neotest").summary.close()
					end, { buffer = true, silent = true, desc = "Close neotest summary" })
				end,
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "neotest-output",
				callback = function()
					vim.keymap.set("n", "q", function()
						vim.cmd("q")
					end, { buffer = true, silent = true, desc = "Close neotest output" })
				end,
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "neotest-output-panel",
				callback = function()
					vim.keymap.set("n", "q", function()
						require("neotest").output_panel.close()
					end, { buffer = true, silent = true, desc = "Close neotest output panel" })
				end,
			})
		end,
		keys = {
			{
				"<leader>tt",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Toggle neotest",
			},
			{
				"<leader>ta",
				function()
					require("neotest").run.run({
						suite = true,
					})
				end,
				desc = "Run all tests",
			},
			{
				"<leader>tn",
				function()
					require("neotest").run.run()
				end,
				desc = "Run nearest test",
			},
			{
				"<leader>tf",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "Run tests in current file",
			},
			{
				"<leader>twa",
				function()
					require("neotest").watch.toggle({
						suite = true,
					})
				end,
				desc = "Toggle watching all tests",
			},
			{
				"<leader>twn",
				function()
					require("neotest").watch.toggle()
				end,
				desc = "Toggle watching nearest test",
			},
			{
				"<leader>twf",
				function()
					require("neotest").watch.toggle(vim.fn.expand("%"))
				end,
				desc = "Toggle watching tests in current file",
			},
			{
				"<leader>to",
				function()
					require("neotest").output.open()
				end,
				desc = "toggle neotest output",
			},
			{
				"<leader>tO",
				function()
					require("neotest").output_panel.toggle()
				end,
				desc = "toggle neotest output panel",
			},
		},
	},
}
