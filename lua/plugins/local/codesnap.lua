return {
	{
		"codesnap",
		dir = vim.fn.stdpath("config") .. "/plugins/codesnap",
		lazy = false,
		config = function(_, opts)
			local CodeSnap = require("codesnap")

			vim.keymap.set({ "n", "x", "v" }, "<leader>cs", function()
				local visual = vim.fn.mode():match("[vV]") ~= nil
				CodeSnap.snapshot({ visual = visual, clipboard = true })
			end, {
				desc = "CodeSnap: Copy selected code to clipboard",
			})
		end,
	},
}
