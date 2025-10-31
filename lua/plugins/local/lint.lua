return {
	{
		"mfussenegger/nvim-lint",
		config = function(_, opts)
			local devenv = require("utils.dev-env")
			local lint = require("lint")

			-- Define linter configurations with their root directory markers
			local linter_configs = {
				eslint = {
					libs = {
						devenv.create_libs_table({
							devenv.check_lib("eslint_d", function()
								vim.env.ESLINT_D_PPID = vim.fn.getpid()
								vim.env.ESLINT_D_ROOT = vim.fn.getcwd()

								return true
							end),
							devenv.check_lib("eslint"),
						}),
					},
					filetypes = {
						"javascript",
						"typescript",
						"typescriptreact",
						"javascriptreact",
						"json",
						"helm",
						"yaml",
					},
					root_markers = {
						"eslint.config.ts",
						"eslint.config.mts",
						"eslint.config.js",
						"eslint.config.mjs",
						".eslintrc.js",
						".eslintrc.cjs",
						".eslintrc.json",
					},
				},
				-- Add more linters here in the future:
				-- python = {
				--     libs = {
				--         { "ruff", "flake8" },  -- Use ruff, fallback to flake8
				--         "mypy",                 -- Always run mypy in parallel
				--     },
				--     filetypes = { "python" },
				--     root_markers = { "pyproject.toml", "setup.py" },
				-- },
			}

			local function flatten_libs(libs_config)
				local result = {}
				for _, item in ipairs(libs_config) do
					if type(item) == "table" then
						-- Nested array: take first available from the fallback chain
						table.insert(result, item[1])
					else
						-- Flat item: use as-is
						table.insert(result, item)
					end
				end
				return result
			end

			lint.linters_by_ft = {}
			for linter_name, config in pairs(linter_configs) do
				local linters = flatten_libs(config.libs)
				for _, ft in ipairs(config.filetypes) do
					lint.linters_by_ft[ft] = lint.linters_by_ft[ft] or {}
					vim.list_extend(lint.linters_by_ft[ft], linters)
				end
			end

			-- Get flat list of all possible linters
			local all_linters = (function()
				local unique = {}
				for _, linters in pairs(lint.linters_by_ft) do
					for _, linter in ipairs(linters) do
						unique[linter] = true
					end
				end
				return vim.tbl_keys(unique)
			end)()

			local root_cache = {}

			--- Find root directory by walking up from start_path looking for marker files
			--- @param start_path string Starting path (file or directory)
			--- @param markers table List of file names to search for
			--- @return string|nil Root directory path if found
			local function find_root_dir(start_path, markers)
				if not start_path or start_path == "" then
					return nil
				end

				-- Normalize to directory
				local dir = vim.fn.isdirectory(start_path) == 1 and start_path or vim.fn.fnamemodify(start_path, ":p:h")

				if not dir or dir == "" then
					return nil
				end

				local seen = {}
				while dir and dir ~= "" and not seen[dir] do
					seen[dir] = true

					for _, marker in ipairs(markers) do
						local path = dir .. "/" .. marker
						if vim.fn.filereadable(path) == 1 then
							return dir
						end
					end

					local parent = vim.fn.fnamemodify(dir, ":h")
					if parent == dir then
						break
					end
					dir = parent
				end

				return nil
			end

			--- Get root directory for current buffer's filetype
			--- @param bufnr number Buffer number
			--- @return string|nil Root directory path
			local function get_root_for_buffer(bufnr)
				-- Check cache first
				if root_cache[bufnr] then
					return root_cache[bufnr]
				end

				local bufname = vim.api.nvim_buf_get_name(bufnr)
				if not bufname or bufname == "" then
					return nil
				end

				local filetype = vim.bo[bufnr].filetype
				if not filetype or filetype == "" then
					return nil
				end

				-- Collect all root markers for this filetype
				local markers = {}
				for linter_name, config in pairs(linter_configs) do
					if vim.tbl_contains(config.filetypes, filetype) then
						vim.list_extend(markers, config.root_markers)
					end
				end

				if #markers == 0 then
					return nil
				end

				-- Find and cache root
				local root = find_root_dir(bufname, markers)
				root_cache[bufnr] = root
				return root
			end

			-- Invalidate cache on buffer delete
			vim.api.nvim_create_autocmd("BufDelete", {
				callback = function(ev)
					root_cache[ev.buf] = nil
				end,
			})

			vim.api.nvim_create_autocmd({ "InsertLeave", "BufEnter", "BufWritePost", "TextChanged" }, {
				callback = function(ev)
					local root = get_root_for_buffer(ev.buf)

					if root and root ~= "" then
						lint.try_lint(nil, { cwd = root })
					else
						lint.try_lint()
					end
				end,
			})

			-- Clear diagnostics on insert enter
			vim.api.nvim_create_autocmd("InsertEnter", {
				callback = function(ev)
					for _, linter_name in ipairs(all_linters) do
						local ns = lint.get_namespace(linter_name)
						vim.diagnostic.reset(ns, ev.buf)
					end
				end,
				desc = "Clear lint diagnostics on insert mode",
			})
		end,
	},
}
