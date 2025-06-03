return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			bigfile = { enabled = true },
			notifier = {
				enabled = true,

				top_down = false,
			},

			indent = {
				enabled = true,
				indent = {
					char = "▎",
				},

				scope = {
					char = "▎",
				},

				animate = {
					enabled = false,
				},
			},

			image = {
				doc = {
					enabled = false,
				},
			},

			terminal = {},
		},
		config = function(_, config)
			require("snacks").setup(config)
			local C = require("catppuccin.palettes").get_palette()

			vim.api.nvim_set_hl(0, "SnacksIndent", { fg = C.surface0 })
			vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#3b4261" })

			-- create command Notifications to show the notifications
			vim.api.nvim_create_user_command("Notifications", function()
				require("snacks").notifier.show_history()
			end, {
				desc = "Show notifications",
			})

			-- create command BufferDelete to delete the current buffer
			vim.api.nvim_create_user_command("BufferDelete", function()
				require("snacks").bufdelete.delete()

				require("snacks").notifier.notify("Buffer deleted", "info")
			end, {
				desc = "Delete current buffer",
			})

			-- create command BufferDeleteAll to delete all buffers
			vim.api.nvim_create_user_command("BufferDeleteAll", function()
				require("snacks").bufdelete.all()

				require("snacks").notifier.notify("All buffers deleted", "info")
			end, {
				desc = "Delete all buffers",
			})

			-- create command BufferDeleteOther to delete all buffers except the current one
			vim.api.nvim_create_user_command("BufferDeleteOther", function()
				require("snacks").bufdelete.other()

				require("snacks").notifier.notify("All other buffers deleted", "info")
			end, {
				desc = "Delete all buffers except the current one",
			})

			vim.keymap.set({ "n", "v" }, "<leader>dd", function()
				vim.cmd("BufferDelete")
			end, { noremap = true, desc = "Delete Buffer" })

			vim.keymap.set({ "n", "v" }, "<leader>dD", function()
				vim.cmd("BufferDeleteAll")
			end, { noremap = true, desc = "Delete all buffers" })

			vim.keymap.set({ "n", "v" }, "<leader><leader>dd", function()
				vim.cmd("BufferDeleteOther")
			end, { noremap = true, desc = "Delete all buffers except the current one" })

			local terminal_context = {
				mode = "n", ---- default terminal mode
				height = 20,
			}

			local create_terminal = function()
				local terminal, created = require("snacks").terminal.get(nil, {
					auto_close = true,
					auto_insert = false,
					start_insert = terminal_context.mode == "i" or terminal_context.mode == "t",

					win = {
						style = "minimal",
						height = terminal_context.height,
						position = "bottom",
						enter = false,
					},
				})

				-- Throw an error if the terminal is not created
				if not terminal then
					require("snacks").notifier.notify("Terminal not created", "error")
					return nil, false
				end

				if created then
					vim.api.nvim_create_autocmd("BufEnter", {
						buffer = terminal.buf,
						callback = function()
							-- We could also force the mode here if needed
							if terminal_context.mode == "i" or terminal_context.mode == "t" then
								vim.cmd("startinsert")
							else
								vim.cmd("stopinsert")
							end
						end,
					})

					vim.api.nvim_create_autocmd("ModeChanged", {
						buffer = terminal.buf,
						callback = function()
							-- store the current terminal mode when switching
							terminal_context.mode = vim.v.event.new_mode
						end,
					})

					-- Track window height on WinClosed
					vim.api.nvim_create_autocmd("WinClosed", {
						buffer = terminal.buf,
						callback = function()
							local win = vim.fn.bufwinid(terminal.buf)
							if win ~= -1 then
								terminal_context.height = vim.api.nvim_win_get_height(win)
							end
						end,
					})
				end

				return terminal, created
			end

			local show_terminal = function()
				local terminal, created = create_terminal()

				-- Throw an error if the terminal is not created
				if not terminal then
					require("snacks").notifier.notify("Terminal not created", "error")
					return
				end

				if created then
					terminal:focus()
				else
					terminal:show()
					vim.api.nvim_win_set_height(terminal.win, terminal_context.height)
					terminal:focus()
				end

				return terminal
			end

			local toggle_terminal = function()
				local terminal, created = create_terminal()

				-- Throw an error if the terminal is not created
				if not terminal then
					require("snacks").notifier.notify("Terminal not created", "error")
					return
				end

				if created then
					terminal:focus()
				else
					if terminal:valid() then
						terminal:hide()
					else
						terminal:show()
						vim.api.nvim_win_set_height(terminal.win, terminal_context.height)
						terminal:focus()
					end
				end

				return terminal
			end

			vim.keymap.set({ "n", "i", "v", "t" }, "<C-j>", function()
				toggle_terminal()
			end, { noremap = true, silent = true })

			-- Set terminal to selected/open file
			local set_terminal_to_file = function()
				local cwd
				local ft = vim.bo.filetype
				if ft == "oil" then
					local oil = require("oil")
					local entry = oil.get_cursor_entry()
					if not entry then
						vim.notify("No entry selected", vim.log.levels.WARN)
						return
					end
					local path = oil.get_current_dir() .. entry.name
					local stat = vim.loop.fs_stat(path)
					if stat and stat.type == "directory" then
						cwd = path
					else
						cwd = vim.fn.fnamemodify(path, ":h")
					end
				else
					local file = vim.api.nvim_buf_get_name(0)
					if file == "" then
						cwd = vim.fn.getcwd()
					else
						local stat = vim.loop.fs_stat(file)
						if stat and stat.type == "directory" then
							cwd = file
						else
							cwd = vim.fn.fnamemodify(file, ":h")
						end
					end
				end
				local terminal = show_terminal()
				if terminal then
					local ok, channel_id = pcall(vim.api.nvim_buf_get_var, terminal.buf, "terminal_job_id")
					if ok and channel_id then
						vim.api.nvim_chan_send(channel_id, "cd " .. cwd .. "\n")
						vim.api.nvim_chan_send(channel_id, "clear\n")
					else
						require("snacks").notifier.notify("Terminal not created", "error")
						return
					end
					terminal:focus()
				else
					require("snacks").notifier.notify("Terminal not created", "error")
				end
			end

			vim.keymap.set({ "n", "i", "v", "t" }, "<leader>ot", function()
				set_terminal_to_file()
			end, { noremap = true, silent = true })
		end,
	},
}
