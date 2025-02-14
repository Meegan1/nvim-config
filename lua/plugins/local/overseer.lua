return {
	{
		"stevearc/overseer.nvim",
		opts = {},
		config = function(_, opts)
			require("overseer").setup(opts)

			-- Add keymap <leader>oo to toggle the overseer window
			vim.keymap.set("n", "<leader>oo", function()
				require("overseer").toggle()
			end, { noremap = true, silent = true, desc = "Open overseer" })

			-- Add keymap <leader>or to run a command in the overseer window
			vim.keymap.set("n", "<leader>or", function()
				vim.cmd("OverseerRun")
			end, { noremap = true, silent = true, desc = "Run command in overseer" })
		end,
	},
}
