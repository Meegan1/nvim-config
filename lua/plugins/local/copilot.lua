return {
	{
		"zbirenbaum/copilot.lua",

		cmd = "Copilot",
		event = "InsertEnter",
		opts = function()
			local logger = require("copilot.logger")

			local allowed_buflisted_filetypes = {
				"gitcommit",
			}

			return {
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
				should_attach = function(_, bufname)
					if not vim.bo.buflisted then
						if vim.tbl_contains(allowed_buflisted_filetypes, vim.bo.ft) then
							return true
						end

						logger.debug("not attaching, buffer is not 'buflisted'")
						return false
					end

					if vim.bo.buftype ~= "" then
						logger.debug("not attaching, buffer 'buftype' is " .. vim.bo.buftype)
						return false
					end

					return true
				end,
			}
		end,
		config = function(_, opts)
			require("copilot").setup(opts)
		end,
	},
}
