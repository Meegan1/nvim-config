return {
	{
		"zbirenbaum/copilot.lua",

		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			copilot_model = "gpt-4o-copilot",
			suggestion = {
				auto_trigger = true,
				keymap = {
					accept = false,
					accept_word = "<C-l>",
					accept_line = "<C-S-l>",
					next = false,
					prev = false,
					dismiss = false,
				},
			},
			filetypes = {
				yaml = true,
				markdown = true,
				gitcommit = true,
			},
		},
		config = function(_, opts)
			require("copilot").setup(opts)
		end,
	},
}
