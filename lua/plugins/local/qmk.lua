return {
	{
		"codethread/qmk.nvim",
		config = function()
			---@type qmk.UserConfig
			local conf = {
				name = "glove80",
				layout = {
					"x x x x x _ _ _ _ _ _ _ _ _ _ _ x x x x x",
					"x x x x x x _ _ _ _ _ _ _ _ _ x x x x x x",
					"x x x x x x _ _ _ _ _ _ _ _ _ x x x x x x",
					"x x x x x x _ _ _ _ _ _ _ _ _ x x x x x x",
					"x x x x x x _ x x x _ x x x _ x x x x x x",
					"x x x x x _ _ x x x _ x x x _ _ x x x x x",
				},
				variant = "zmk",
			}
			require("qmk").setup(conf)
		end,
	},
}
