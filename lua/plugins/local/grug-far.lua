return {
	{
		"MagicDuck/grug-far.nvim",
		opts = {
			headerMaxWidth = 80,
			startInInsertMode = false,

			prefills = {
				flags = "-u --hidden --glob=!{.git,node_modules,.nx,.next,dist,coverage}",
			},
		},
		cmd = "GrugFar",
		keys = {
			{
				"<leader>ff",
				function()
					local grug = require("grug-far")
					local is_open = grug.is_instance_open("default")

					if is_open then
						grug.close_instance("default")
					else
						grug.open({
							transient = true,
							instanceName = "default",
						})
					end
				end,
				mode = { "n", "v" },
				desc = "Search and Replace",
			},
		},

		config = function(_, opts)
			require("grug-far").setup(opts)

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "grug-far",
				callback = function()
					vim.keymap.set("n", "q", function()
						require("grug-far").close_instance("default")
					end, { buffer = true, silent = true, desc = "Close grug-far window" })
				end,
			})
		end,
	},
}
