return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
		"nvim-telescope/telescope.nvim", -- Optional: For using slash commands
		{ "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
	},
	config = function(_, config)
		require("codecompanion").setup(vim.tbl_extend("force", {
			adapters = {
				copilot = function()
					return require("codecompanion.adapters").extend("copilot", {
						schema = {
							model = {
								default = "claude-3.5-sonnet",
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
								provider = "telescope",
							},
						},
					},

					agents = {
						adapter = "copilot",
					},
				},
				inline = {
					adapter = "copilot",
				},
			},
		}, config))

		vim.keymap.set({ "n", "x" }, "<leader>cc", function()
			vim.cmd("CodeCompanionChat Toggle")
		end, { noremap = true, silent = true, desc = "Toggle the CodeCompanion chat" })

		vim.keymap.set({ "n", "x" }, "<leader>ci", function()
			vim.cmd("CodeCompanion")
		end, { noremap = true, silent = true, desc = "Open the CodeCompanion inline chat" })

		vim.keymap.set({ "n", "x" }, "<leader>ca", function()
			local mode = vim.api.nvim_get_mode().mode
			if mode == "v" or mode == "V" or mode == "\22" then -- "\22" is the code for <CTRL-V>
				vim.cmd("CodeCompanionChat Add")
			else
				local Chat = require("codecompanion").last_chat()
				local codecompanion_config = require("codecompanion.config")
				local buf = require("codecompanion.utils.buffers")
				local file_utils = require("codecompanion.utils.files")

				-- Add the current buffer to the chat using vim api
				local current_buffer = vim.api.nvim_get_current_buf()
				local name = vim.api.nvim_buf_get_name(current_buffer):match("([^/]+)$")
				local path = vim.api.nvim_buf_get_name(current_buffer)
				local selected = {
					bufnr = current_buffer,
					name = name,
					path = path,
				}

				local content
				if not vim.api.nvim_buf_is_loaded(selected.bufnr) then
					content = file_utils.read(selected.path)
					if content == "" then
						return log:warn("Could not read the file: %s", selected.path)
					end
					content = "```" .. file_utils.get_filetype(selected.path) .. "\n" .. content .. "\n```"
				else
					content = buf.format(selected.bufnr)
				end

				Chat:add_message({
					role = codecompanion_config.constants.USER_ROLE,
					content = string.format(
						[[Here is the content from %s (which has a buffer number of _%d_ and a filepath of `%s`):

                %s]],
						selected.name,
						selected.bufnr,
						selected.path,
						content
					),
				}, { visible = false })
				vim.notify(string.format("Buffer `%s` content added to the chat", selected.name), vim.log.levels.INFO)
			end
		end, { noremap = true, silent = true, desc = "Add the current buffer to the chat" })

		vim.keymap.set({ "n" }, "<leader>cd", function()
			local chat = require("codecompanion").last_chat()

			if not chat then
				return
			end

			local messages = chat.messages
			if not messages or #messages == 0 then
				vim.notify("No messages to delete", vim.log.levels.INFO)
				return
			end

			local entries = {}
			for i, message in ipairs(messages) do
				table.insert(entries, { index = i, content = message.content })
			end

			-- Reverse the order of the messages so that the most recent message is at the top
			table.sort(entries, function(a, b)
				return a.index > b.index
			end)

			local previewers = require("telescope.previewers")

			require("telescope.pickers")
				.new({}, {
					prompt_title = "Select Message to Remove",
					finder = require("telescope.finders").new_table({
						results = entries,
						entry_maker = function(entry)
							return {
								value = entry,
								display = entry.content:gsub("\n", " "),
								index = entry.index,
								ordinal = entry.content,
							}
						end,
					}),
					previewer = previewers.new_buffer_previewer({
						define_preview = function(self, entry, status)
							vim.api.nvim_buf_set_lines(
								self.state.bufnr,
								0,
								-1,
								false,
								vim.split(entry.value.content, "\n")
							)
						end,
					}),
					sorter = require("telescope.config").values.generic_sorter({}),
					attach_mappings = function(prompt_bufnr)
						local actions = require("telescope.actions")
						local action_state = require("telescope.actions.state")

						actions.select_default:replace(function()
							local selection = action_state.get_selected_entry()
							actions.close(prompt_bufnr)

							if selection then
								table.remove(chat.messages, selection.value.index)
								vim.notify("Message removed: " .. selection.value.index, vim.log.levels.INFO)
								chat:render()
							end
						end)

						return true
					end,
				})
				:find()
		end, { noremap = true, silent = true, desc = "Delete a message from the chat" })
	end,
}
