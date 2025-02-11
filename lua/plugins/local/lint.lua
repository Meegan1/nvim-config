return {
	{
		"mfussenegger/nvim-lint",
		config = function(_, opts)
			local lint = require("lint")

			-- Check if eslint_d is installed locally and use it if it is
			local eslint_d_installed = vim.fn.filereadable("node_modules/.bin/eslint_d")
			local eslint = eslint_d_installed == 1 and "eslint_d" or "eslint"
			if eslint_d_installed then
				vim.env.ESLINT_D_PPID = vim.fn.getpid()
			end

			lint.linters_by_ft = {
				javascript = { eslint },
				typescript = { eslint },
				typescriptreact = { eslint },
				javascriptreact = { eslint },
				liquid = { eslint },
				json = { eslint },
				helm = { eslint },
				yaml = { eslint },
				nix = { "nix-linter" },
				blade = { eslint },
				php = { eslint },
			}

			-- get flat list of all possible linters from linters_by_ft
			local possible_linters = (function()
				local unique_linters = {}
				for _, linters in pairs(lint.linters_by_ft) do
					for _, linter in ipairs(linters) do
						unique_linters[linter] = true
					end
				end
				return vim.tbl_keys(unique_linters)
			end)()

			vim.api.nvim_create_autocmd({ "InsertLeave", "BufEnter", "BufWritePost" }, {
				callback = function()
					-- try_lint without arguments runs the linters defined in `linters_by_ft`
					-- for the current filetype
					lint.try_lint()
				end,
			})

			local function clear_lint_on_insert()
				local current_buf = vim.api.nvim_get_current_buf()

				-- Clear diagnostics for each linter's namespace
				for _, linter_name in ipairs(possible_linters) do
					local ns = lint.get_namespace(linter_name)
					vim.diagnostic.reset(ns, current_buf)
				end
			end

			-- Clear the linter on insert mode
			vim.api.nvim_create_autocmd("InsertEnter", {
				callback = clear_lint_on_insert,
				pattern = "*", -- or specific filetypes like {"python", "lua"}
				desc = "Clear lint messages on insert mode",
			})
		end,
	},
}
