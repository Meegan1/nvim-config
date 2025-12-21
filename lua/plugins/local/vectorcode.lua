return {
	{
		"Davidyz/VectorCode",
		version = "*", -- optional, depending on whether you're on nightly or release
		dependencies = {
			"nvim-lua/plenary.nvim",
			"console_log",
		},
		enabled = false,
		config = function(_, opts)
			local console_log = require("console_log")
			local Job = require("plenary.job")
			local async = require("plenary.async")
			local path = require("plenary.path")

			local function async_ensure_vectorcode_installed(callback)
				-- Check if uv is available
				Job:new({
					command = "sh",
					args = { "-c", "command -v uv" },
					on_exit = function(_, return_val)
						local has_uv = return_val == 0
						if not has_uv then
							vim.schedule(function()
								console_log.log(
									"uv is not installed, skipping install. Please install uv first.",
									vim.log.levels.INFO
								)
							end)
							callback(false)
							return
						end

						-- Check if vectorcode is installed
						Job:new({
							command = "sh",
							args = { "-c", "command -v vectorcode" },
							on_exit = function(_, return_val)
								local is_installed = return_val == 0

								vim.schedule(function()
									if not is_installed then
										console_log.log("Installing VectorCode...", vim.log.levels.INFO)
									else
										console_log.log("Updating VectorCode...", vim.log.levels.INFO)
									end
								end)

								-- Install or update vectorcode
								Job:new({
									command = "uv",
									args = { "tool", "install", "--upgrade", "vectorcode" },
									on_exit = function(_, return_val)
										if return_val ~= 0 then
											vim.schedule(function()
												console_log.log("Failed to install VectorCode", vim.log.levels.ERROR)
											end)
											callback(false)
										else
											vim.schedule(function()
												console_log.log(
													"VectorCode installed successfully",
													vim.log.levels.INFO
												)
											end)
											callback(true)
										end
									end,
								}):start()
							end,
						}):start()
					end,
				}):start()
			end

			local function async_check_chroma_server(callback)
				-- Try localhost first
				Job:new({
					command = "curl",
					args = { "-s", "-o", "/dev/null", "-w", "%{http_code}", "http://localhost:8000/api/v1/heartbeat" },
					on_exit = function(j, _)
						local output = j:result()[1]
						local status_code = tonumber(output)

						if status_code and status_code >= 200 and status_code < 300 then
							vim.schedule(function()
								console_log.log("Chroma DB server found on localhost:8000", vim.log.levels.INFO)
							end)
							callback("localhost", "8000")
							return
						end

						-- Try Docker host if localhost failed
						Job:new({
							command = "curl",
							args = {
								"-s",
								"-o",
								"/dev/null",
								"-w",
								"%{http_code}",
								"http://host.docker.internal:8000/api/v1/heartbeat",
							},
							on_exit = function(j, _)
								local output2 = j:result()[1]
								local status_code2 = tonumber(output2)

								if status_code2 and status_code2 >= 200 and status_code2 < 300 then
									vim.schedule(function()
										console_log.log(
											"Chroma DB server found on host.docker.internal:8000",
											vim.log.levels.INFO
										)
									end)
									callback("host.docker.internal", "8000")
								else
									vim.schedule(function()
										console_log.log("No Chroma DB server found", vim.log.levels.INFO)
									end)
									callback(nil, nil)
								end
							end,
						}):start()
					end,
				}):start()
			end

			local function update_config_file(host, port)
				if not (host and port) then
					return
				end

				-- Use current working directory
				local cwd = vim.fn.getcwd()
				local config_dir = path:new(cwd, ".vectorcode")
				local config_file = config_dir:joinpath("config.json")

				-- Create directory if it doesn't exist
				if not config_dir:exists() then
					vim.fn.mkdir(config_dir.filename, "p")
				end

				-- Read existing config if it exists
				local config = {}
				local needs_update = true

				if config_file:exists() then
					local content = config_file:read()
					local ok, existing_config = pcall(vim.json.decode, content)
					if ok then
						config = existing_config
						-- Check if values are already set to the same values
						if config.host == host and config.port == port then
							needs_update = false
						end
					end
				end

				-- Only update if the values have changed or don't exist
				if needs_update then
					-- Update config with new host and port
					config.host = host
					config.port = port

					-- Write the updated config back to file
					local json_str = vim.json.encode(config)
					config_file:write(json_str, "w")
					console_log.log("Updated " .. config_file.filename .. " with server details", vim.log.levels.INFO)
				end
			end

			-- Start async initialization
			async.run(function()
				-- Initialize the plugin immediately with default settings
				async.util.scheduler()
				local vectorcode = require("vectorcode")
				vectorcode.setup(opts)

				-- Run async tasks in the background
				async_ensure_vectorcode_installed(function(is_installed)
					if is_installed then
						async_check_chroma_server(function(host, port)
							if host and port then
								vim.schedule(function()
									update_config_file(host, port)
								end)
							end
						end)
					end
				end)
			end, function(err)
				if err then
					vim.schedule(function()
						console_log.log("Error in VectorCode initialization: " .. tostring(err), vim.log.levels.ERROR)
					end)
				end
			end)
		end,
	},
}
