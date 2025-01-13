return {
	{
		"mrjones2014/smart-splits.nvim",
		keys = {
			{
				"<C-w>h",
				function()
					require("smart-splits").move_cursor_left()
				end,
				mode = { "n", "t" },
				desc = "Move left",
			},
			{
				"<C-w>l",
				function()
					require("smart-splits").move_cursor_right()
				end,
				mode = { "n", "t" },
				desc = "Move right",
			},
			{
				"<C-w>k",
				function()
					require("smart-splits").move_cursor_up()
				end,
				mode = { "n", "t" },
				desc = "Move up",
			},
			{
				"<C-w>j",
				function()
					require("smart-splits").move_cursor_down()
				end,
				mode = { "n", "t" },
				desc = "Move down",
			},
			{
				"<A-S-w>h",
				function()
					require("smart-splits").swap_buf_left()
				end,
				mode = { "n", "t" },
				desc = "Swap buffer left",
			},
			{
				"<A-S-w>l",
				function()
					require("smart-splits").swap_buf_right()
				end,
				mode = { "n", "t" },
				desc = "Swap buffer right",
			},
			{
				"<A-S-w>k",
				function()
					require("smart-splits").swap_buf_up()
				end,
				mode = { "n", "t" },
				desc = "Swap buffer up",
			},
			{
				"<A-S-w>j",
				function()
					require("smart-splits").swap_buf_down()
				end,
				mode = { "n", "t" },
				desc = "Swap buffer down",
			},
		},
		opts = {
			at_edge = "stop",
		},
	},
}
