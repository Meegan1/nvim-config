return {
	{
		"AndreM222/copilot-lualine",
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"AndreM222/copilot-lualine",
			"nvim-tree/nvim-web-devicons",
		},
		config = true,
		opts = function()
			return {
				sections = {
					lualine_a = { "mode" },
					lualine_b = {
						"branch",
						"diff",
						{
							"diagnostics",
							sources = { "nvim_diagnostic" },
							symbols = { error = " ", warn = " ", info = " ", hint = " " },
						},
					},
					lualine_c = {
						function()
							return require("auto-session.lib").current_session_name(true)
						end,
					},
					lualine_x = {
						-- Macro recording
						{
							function()
								return "recording @" .. vim.fn.reg_recording()
							end,
							cond = function()
								return vim.fn.reg_recording() ~= ""
							end,
							color = { fg = "#f8f8f2", bg = "#282a36" },
						},
						"copilot",
						"filetype",
					},
					lualine_y = { "progress" },
					lualine_z = { "location", "searchcount" },
				},
			}
		end,
	},
}
