return {
	"aznhe21/actions-preview.nvim",
	config = function()
		require("actions-preview").setup({
			telescope = vim.tbl_extend("force", require("telescope.themes").get_dropdown(), {
				initial_mode = "normal",
			}),
		})

		vim.keymap.set({ "n", "i", "v" }, "<C-.>", function()
			require("actions-preview").code_actions({})
		end)
	end,
}
