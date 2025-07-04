return {
	{
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
			"ibhagwan/fzf-lua", -- For config file selection
			"console_log",
		},
		config = function()
			local console_log = require("console_log")
			local Job = require("plenary.job")
			local async = require("plenary.async")
			local Path = require("plenary.path")
			local mcphub = require("mcphub")

			-- Constants and default configuration
			local CONFIG_FILENAME = ".mcpservers.json"
			local PORT_RANGE_START = 1024
			local PORT_RANGE_END = 65535
			local DEFAULT_CONFIG = {
				mcpServers = {
					fetch = {
						command = "uvx",
						disabled = false,
						args = {
							"mcp-server-fetch",
						},
					},
					["filesystem"] = {
						command = "npx",
						args = {
							"-y",
							"@modelcontextprotocol/server-filesystem",
							".",
						},
					},
				},
			}

			-- Async function to check if mcp-hub is installed
			local function async_ensure_mcp_hub_installed(callback)
				Job:new({
					command = "sh",
					args = { "-c", "command -v mcp-hub" },
					on_exit = function(_, return_val)
						local is_installed = return_val == 0

						if not is_installed then
							vim.schedule(function()
								console_log.log("Installing mcp-hub...", vim.log.levels.INFO)
							end)

							-- Check if bun is available
							Job:new({
								command = "sh",
								args = { "-c", "command -v bun" },
								on_exit = function(_, return_val)
									local has_bun = return_val == 0
									local install_cmd = has_bun and "bun" or "npm"
									local install_args = has_bun and { "install", "-g", "mcp-hub@latest" }
										or { "install", "-g", "mcp-hub@latest" }

									Job
										:new({
											command = install_cmd,
											args = install_args,
											on_exit = function(_, return_val)
												if return_val ~= 0 then
													vim.schedule(function()
														console_log.log(
															"Failed to install mcp-hub",
															vim.log.levels.ERROR
														)
													end)
													callback(false)
												else
													vim.schedule(function()
														console_log.log(
															"mcp-hub installed successfully",
															vim.log.levels.INFO
														)
													end)
													callback(true)
												end
											end,
										})
										:start()
								end,
							}):start()
						else
							callback(true)
						end
					end,
				}):start()
			end

			local utils = {}

			-- Helper utilities
			-- Get the path to the config file in a specified directory
			utils.get_config_path = function(dir)
				return Path:new(dir or vim.fn.getcwd(), CONFIG_FILENAME).filename
			end

			-- Check if config file exists at the specified path
			utils.config_exists = function(path)
				return vim.loop.fs_stat(path) ~= nil
			end

			utils.get_json_string = function(json)
				local json_str = vim.json.encode(json)
				if vim.fn.executable("jq") == 1 then
					local temp_file = os.tmpname()
					local temp = io.open(temp_file, "w")

					if not temp then
						console_log.log("Failed to create temporary file", vim.log.levels.ERROR)
						return json_str
					end

					temp:write(json_str)
					temp:close()

					local formatted_json = vim.fn.system("jq . " .. temp_file)
					os.remove(temp_file)

					return formatted_json
				else
					return json_str
				end
			end

			-- Create a default config file at the specified path
			utils.create_config = function(path)
				local file = io.open(path, "w")
				if not file then
					console_log.log("Failed to create config file", vim.log.levels.ERROR)
					return false
				end

				-- Write formatted JSON with proper indentation if jq is available
				local json_str = utils.get_json_string(DEFAULT_CONFIG)
				file:write(json_str)

				file:close()

				console_log.log("Created MCP config at " .. path, vim.log.levels.INFO)
				return true
			end

			-- Hash the current working directory to generate a unique port
			local function hash_string(str)
				local hash = 5381
				for i = 1, #str do
					hash = ((hash * 33) + string.byte(str, i)) % (2 ^ 32)
				end
				return hash
			end

			-- Start MCP Hub with the specified config path
			utils.start_mcp = function(config_path)
				local cwd = vim.fn.getcwd()
				local hashed_cwd = hash_string(cwd)
				local port = PORT_RANGE_START + (hashed_cwd % (PORT_RANGE_END - PORT_RANGE_START + 1))

				mcphub.setup({
					port = port,
					config = config_path,
					shutdown_delay = 0,
					log = {
						level = vim.log.levels.ERROR,
						to_file = false,
						file_path = nil,
						prefix = "MCPHub",
					},
				})
				console_log.log(
					"MCP Hub started on port " .. port .. " with config: " .. config_path,
					vim.log.levels.INFO
				)
				return true
			end

			-- Core functionality
			local core = {}
			-- Use config from the current working directory
			core.use_local_config = function()
				local config_path = utils.get_config_path()

				-- Create config if it doesn't exist
				if not utils.config_exists(config_path) and not utils.create_config(config_path) then
					return false
				end

				return utils.start_mcp(config_path)
			end

			-- Select a directory for the config file using FZF
			core.select_config_location = function()
				require("fzf-lua").fzf_exec("find " .. vim.fn.getcwd() .. " -type d", {
					prompt = "Select directory for config > ",
					actions = {
						["default"] = function(selected)
							if #selected > 0 then
								local dir_path = selected[1]
								local config_path = utils.get_config_path(dir_path)

								-- Create config if it doesn't exist
								if not utils.config_exists(config_path) and not utils.create_config(config_path) then
									return false
								end

								utils.start_mcp(config_path)
							end
						end,
					},
				})
			end

			-- Auto-detect and start if config exists in current directory
			core.auto_detect_and_start = function()
				local config_path = utils.get_config_path()

				if utils.config_exists(config_path) then
					console_log.log(
						"Found MCP config file in current directory, starting automatically",
						vim.log.levels.INFO
					)
					return utils.start_mcp(config_path)
				end
				return false
			end

			-- Prompt user to select config method and start MCP Hub
			core.prompt_and_start = function(action_name)
				vim.ui.select({ "Yes (use current directory)", "No (pick a location)" }, {
					prompt = "Do you want to use a local " .. CONFIG_FILENAME .. "?",
					default = 1,
				}, function(choice)
					if choice == nil then
						console_log.log("MCP Hub " .. action_name .. " canceled", vim.log.levels.INFO)
						return
					elseif choice == "Yes (use current directory)" then
						core.use_local_config()
					else
						core.select_config_location()
					end
				end)
			end

			-- Try to auto-start, otherwise define commands
			if not core.auto_detect_and_start() then
				vim.api.nvim_create_user_command("MCPStart", function()
					core.prompt_and_start("startup")
				end, { desc = "Start MCP Hub server with configuration options" })
			end

			-- Always define these commands regardless of auto-start
			vim.api.nvim_create_user_command("MCPRestart", function()
				mcphub.get_hub_instance():stop()
				mcphub.get_hub_instance():start()
			end, { desc = "Restart MCP Hub server with configuration options" })

			vim.api.nvim_create_user_command("MCPStop", function()
				mcphub.get_hub_instance():stop()
				console_log.log("MCP Hub stopped", vim.log.levels.INFO)
			end, { desc = "Stop MCP Hub server" })

			vim.api.nvim_create_user_command("MCPCreate", function()
				local config_path = utils.get_config_path()

				if utils.config_exists(config_path) then
					console_log.log("Config file already exists at " .. config_path, vim.log.levels.INFO)
					return
				end

				utils.create_config(config_path)
			end, { desc = "Create a new MCP config file" })

			-- Start async initialization
			async.run(function()
				-- Initialize the plugin immediately
				async.util.scheduler()

				-- Run async tasks in the background
				async_ensure_mcp_hub_installed(function(is_installed)
					if is_installed then
						vim.schedule(function()
							if not core.auto_detect_and_start() then
								vim.api.nvim_create_user_command("MCPStart", function()
									core.prompt_and_start("startup")
								end, { desc = "Start MCP Hub server with configuration options" })
							end

							-- Always define these commands regardless of auto-start
							vim.api.nvim_create_user_command("MCPRestart", function()
								mcphub.get_hub_instance():stop()
								mcphub.get_hub_instance():start()
							end, { desc = "Restart MCP Hub server with configuration options" })

							vim.api.nvim_create_user_command("MCPStop", function()
								mcphub.get_hub_instance():stop()
								console_log.log("MCP Hub stopped", vim.log.levels.INFO)
							end, { desc = "Stop MCP Hub server" })

							vim.api.nvim_create_user_command("MCPCreate", function()
								local config_path = utils.get_config_path()

								if utils.config_exists(config_path) then
									console_log.log(
										"Config file already exists at " .. config_path,
										vim.log.levels.INFO
									)
									return
								end

								utils.create_config(config_path)
							end, { desc = "Create a new MCP config file" })
						end)
					end
				end)
			end, function(err)
				if err then
					vim.schedule(function()
						console_log.log("Error in MCP Hub initialization: " .. tostring(err), vim.log.levels.ERROR)
					end)
				end
			end)
		end,
	},
}
