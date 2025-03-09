return {
	{
		"zbirenbaum/copilot.lua",

		-- https://github.com/zbirenbaum/copilot.lua/issues/365#issuecomment-2708887411
		branch = "create-pull-request/update-copilot-dist",

		cmd = "Copilot",
		event = "InsertEnter",
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
		config = function(_, opts)
			local new_opts = vim.tbl_extend("force", opts, {
				server_opts_overrides = {
					cmd = {
						"node",
						vim.api.nvim_get_runtime_file("copilot/dist/language-server.js", false)[1],
						"--stdio",
					},
					init_options = {
						copilotIntegrationId = "vscode-chat",
					},
				},
			})

			require("copilot").setup(new_opts)

			local util = require("copilot.util")
			local orig_get_editor_configuration = util.get_editor_configuration

			---@diagnostic disable-next-line: duplicate-set-field
			util.get_editor_configuration = function()
				local config = orig_get_editor_configuration()

				return vim.tbl_extend("force", config, {
					github = {
						copilot = {
							selectedCompletionModel = "gpt-4o-copilot",
						},
					},
				})
			end
		end,
	},
}
