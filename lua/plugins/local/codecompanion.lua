-- Get the current buffer's path relative to project root
local function get_relative_path()
	-- Try to get the root directory using LSP workspace folders first
	local root = vim.lsp.buf.list_workspace_folders()[1]

	if not root then
		-- Fallback: try to find git root
		root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	end

	if not root then
		-- If no root found, return the full path
		return vim.fn.expand("%:p")
	end

	-- Get absolute path of current buffer
	local absolute_path = vim.fn.expand("%:p")
	-- Make it relative to the root
	return vim.fn.fnamemodify(absolute_path, ":~:." .. root .. "/")
end

return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"ravitemer/mcphub.nvim",
	},
	config = function(_, config)
		local copilot_adapter = require("codecompanion.adapters").extend("copilot", {
			schema = {
				model = {
					default = "gpt-4.1",
				},
			},
		})

		require("codecompanion").setup(vim.tbl_extend("force", {
			adapters = {
				copilot = function()
					return require("codecompanion.adapters").extend("copilot", {
						schema = {
							model = {
								default = "gpt-4.1",
							},
						},
					})
				end,
			},
			strategies = {
				chat = {
					adapter = "copilot",
					slash_commands = {
						["buffer"] = {
							opts = {
								provider = "fzf_lua",
							},
						},
					},

					agents = {
						adapter = "copilot",
					},

					roles = {
						llm = function(adapter)
							return string.format(
								" %s%s",
								adapter.formatted_name,
								adapter.parameters.model and " (" .. adapter.parameters.model .. ")" or ""
							)
						end,
						user = " " .. "User",
					},
				},
				inline = {
					adapter = "copilot",
				},
			},
			extensions = {
				mcphub = {
					callback = "mcphub.extensions.codecompanion",
					opts = {
						make_vars = true,
						make_slash_commands = true,
						show_results_in_chat = true,
					},
				},
				vectorcode = {
					opts = {
						add_tool = true,
						add_slash_command = true,
						tool_opts = {},
					},
				},
			},
		}, config))

		vim.keymap.set({ "n", "x" }, "<leader>cc", function()
			vim.cmd("CodeCompanionChat Toggle")
		end, { noremap = true, silent = true, desc = "Toggle the CodeCompanion chat" })

		vim.keymap.set({ "n", "x" }, "<leader>cC", function()
			vim.cmd("CodeCompanionChat")
		end, { noremap = true, silent = true, desc = "Create a new CodeCompanion chat" })

		vim.keymap.set({ "n", "x" }, "<leader>ci", function()
			vim.cmd("CodeCompanion")
		end, { noremap = true, silent = true, desc = "Open the CodeCompanion inline chat" })

		vim.keymap.set({ "n", "x" }, "<leader>ca", function()
			vim.cmd("CodeCompanionActions")
		end, { noremap = true, silent = true, desc = "Open the CodeCompanion actions menu" })

		vim.keymap.set({ "n", "x" }, "<leader>cm", function()
			local models = copilot_adapter.schema.model.choices(copilot_adapter)
			local model_names = {}
			for name, _ in pairs(models) do
				table.insert(model_names, name)
			end

			local Chat = require("codecompanion").last_chat()

			if not Chat then
				return vim.notify("No chat found", vim.log.levels.ERROR)
			end

			vim.ui.select(model_names, {
				prompt = "Select model:",
			}, function(model)
				if model then
					Chat:apply_model(model)
					vim.notify("Model changed to: " .. model)
				end
			end)
		end, { noremap = true, silent = true, desc = "Change the model" })

		vim.keymap.set({ "n", "x" }, "<leader>cb", function()
			local mode = vim.api.nvim_get_mode().mode
			if mode == "v" or mode == "V" or mode == "\22" then -- "\22" is the code for <CTRL-V>
				vim.cmd("CodeCompanionChat Add")
			else
				local Chat = require("codecompanion").last_chat()

				if not Chat then
					return vim.notify("No chat found", vim.log.levels.ERROR)
				end

				local path = get_relative_path()
				local file = vim.api.nvim_buf_get_name(0)

				local id = "<file>" .. path .. "</file>"

				Chat.references:add({
					id = id,
					path = path,
					source = "codecompanion.strategies.chat.slash_commands.file",
					opts = {
						pinned = true,
					},
				})

				vim.notify(string.format("File `%s` content added to the chat", file), vim.log.levels.INFO)
			end
		end, { noremap = true, silent = true, desc = "Add the current buffer to the chat" })
	end,
}
