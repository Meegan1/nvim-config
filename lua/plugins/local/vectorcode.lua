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
					return
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
				else
					vim.notify("VectorCode installed successfully", vim.log.levels.INFO)
				end
			end

			ensure_vectorcode_installed()

			local vectorcode = require("vectorcode")
			vectorcode.setup(opts)
		end,
	},
}
