return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = true,
		opts = {
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
	},
}
