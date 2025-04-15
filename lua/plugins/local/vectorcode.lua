return {
	{
		"Davidyz/VectorCode",
		version = "*", -- optional, depending on whether you're on nightly or release
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function(_, opts)
			local function ensure_vectorcode_installed()
				-- Check if mcp-hub is already installed
				local is_installed = vim.fn.system("command -v vectorcode") ~= ""

				-- Check if uv is available
				local has_uv = vim.fn.system("command -v uv") ~= ""
				if not has_uv then
					vim.notify("uv is not installed, skipping install. Please install uv first.", vim.log.levels.INFO)
					return false
				end

				if not is_installed then
					vim.notify("Installing VectorCode...", vim.log.levels.INFO)
				else
					vim.notify("Updating VectorCode...", vim.log.levels.INFO)
				end

				local install_cmd = "uv tool install --upgrade vectorcode"
				local install_result = vim.fn.system(install_cmd)

				if vim.v.shell_error ~= 0 then
					vim.notify("Failed to install VectorCode: " .. install_result, vim.log.levels.ERROR)
					return false
				else
					vim.notify("VectorCode installed successfully", vim.log.levels.INFO)
					return true
				end
			end

			local function check_chroma_server()
				local curl_cmd = 'curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/api/v1/heartbeat'
				local status_code = tonumber(vim.fn.system(curl_cmd))

				if status_code and status_code >= 200 and status_code < 300 then
					vim.notify("Chroma DB server found on localhost:8000", vim.log.levels.INFO)
					return "localhost", "8000"
				end

				-- Try Docker host if localhost failed
				curl_cmd = 'curl -s -o /dev/null -w "%{http_code}" http://host.docker.internal:8000/api/v1/heartbeat'
				status_code = tonumber(vim.fn.system(curl_cmd))

				if status_code and status_code >= 200 and status_code < 300 then
					vim.notify("Chroma DB server found on host.docker.internal:8000", vim.log.levels.INFO)
					return "host.docker.internal", "8000"
				end

				vim.notify("No Chroma DB server found", vim.log.levels.WARN)
				return nil, nil
			end

			local function update_config_file(host, port)
				if not (host and port) then
					return
				end

				local path = require("plenary.path")

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
					vim.notify("Updated " .. config_file.filename .. " with server details", vim.log.levels.INFO)
				end
			end

			local is_installed = ensure_vectorcode_installed()

			if not is_installed then
				return
			end

			-- Check for Chroma server and update config file if found
			local host, port = check_chroma_server()
			if host and port then
				update_config_file(host, port)
			end

			local vectorcode = require("vectorcode")
			vectorcode.setup(opts)
		end,
	},
}
