return {
	{
		"rmagatti/auto-session",
		lazy = false,
		dependencies = {
			"console_log",
		},
		config = function()
			local console_log = require("console_log")

			local has_neo_tree = pcall(require, "neo-tree")

			local close_neo_tree = function()
				if has_neo_tree then
					return
				end

				require("neo-tree.sources.manager").close_all()
				console_log.log("Closed all NeoTree windows", vim.log.levels.DEBUG, { title = "AutoSession" })
			end

			local open_neo_tree = function()
				if not has_neo_tree then
					return
				end

				console_log.log("Opening NeoTree window", vim.log.levels.DEBUG, { title = "AutoSession" })
				require("neo-tree.sources.manager").show("filesystem")
			end

			local load_oil = function()
				require("oil")
			end

			-- If no directory is provided, don't auto restore the session
			local auto_restore_enabled = (function()
				local argv = vim.fn.argv()
				if #argv == 0 then
					return false
				end

				local path = argv[1]
				if path == nil or path == "" then
					return false
				end

				return true
			end)()

			-- Convert the cwd to a simple file name
			local function get_cwd_as_name()
				local dir = vim.fn.getcwd(0)
				return dir:gsub("[^A-Za-z0-9]", "_")
			end

			local function close_all_floating_wins()
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local config = vim.api.nvim_win_get_config(win)
					if config.relative ~= "" then
						vim.api.nvim_win_close(win, false)
					end
				end
			end

			local overseer = require("overseer")

			require("auto-session").setup({
				auto_restore_enabled = auto_restore_enabled,
				auto_save_enabled = true,
				auto_session_suppress_dirs = { "~/", "~/Documents/Projects", "~/Downloads", "/" },
				bypass_session_save_file_types = { "alpha" },

				-- only save session if we are inside a git repo
				auto_session_create_enabled = function()
					local cmd = "git rev-parse --is-inside-work-tree"
					return vim.fn.system(cmd) == "true\n"
				end,

				pre_save_cmds = {
					close_neo_tree,
					close_all_floating_wins,
					function()
						vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })
					end,
					function()
						require("overseer.window").close()

						overseer.save_task_bundle(
							get_cwd_as_name(),
							-- Passing nil will use config.opts.save_task_opts. You can call list_tasks() explicitly and
							-- pass in the results if you want to save specific tasks.
							nil,
							{ on_conflict = "overwrite" } -- Overwrite existing bundle, if any
						)
					end,
				},

				pre_restore_cmds = {
					load_oil,
					-- Get rid of all previous tasks when restoring a session
					function()
						for _, task in ipairs(overseer.list_tasks({})) do
							task:dispose(true)
						end
					end,
				},

				post_restore_cmds = {
					open_neo_tree,
					function()
						overseer.load_task_bundle(get_cwd_as_name(), { ignore_missing = true })
					end,
					"stopinsert", -- Stop insert mode after restoring session
				},

				no_restore_cmds = {
					load_oil,
				},

				session_lens = {
					load_on_setup = true,
					theme_conf = {
						border = true,
						previewer = false,
						mappings = {
							-- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
							delete_session = { "i", "<C-D>" },
							alternate_session = { "i", "<C-S>" },
						},
					},
				},
			})
		end,
	},
}
