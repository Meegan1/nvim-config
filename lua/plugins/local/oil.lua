local function get_git_ignored_files()
	-- Get the list of ignored files using git
	local proc = vim.system({
		"git",
		"ls-files",
		"--others",
		"--ignored",
		"--exclude-standard",
		"--directory",
	}, {
		cwd = vim.fn.getcwd(),
		text = true,
	})

	local result = proc:wait()

	local git_ignored_files = {}
	local git_ignored_dirs = {}
	local git_ignored_full_paths = {}

	if result.code == 0 then
		for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
			-- Store full paths for checking parent directories
			git_ignored_full_paths[line:gsub("/$", "")] = true

			-- Store directory paths separately
			if line:match("/$") then
				local dir_name = line:gsub("/$", "")
				-- Get just the directory name, not the full path
				local base_dir = vim.fn.fnamemodify(dir_name, ":t")
				git_ignored_dirs[base_dir] = true
			else
				-- Get just the filename, not the full path
				local file_name = vim.fn.fnamemodify(line, ":t")
				git_ignored_files[file_name] = true
			end
		end
	end

	return git_ignored_files, git_ignored_dirs, git_ignored_full_paths
end

local git_ignored_files, git_ignored_dirs, git_ignored_full_paths = get_git_ignored_files()

return {
	{
		"stevearc/oil.nvim",
		opts = {
			view_options = {
				show_hidden = true,
				is_always_hidden = function(name, bufnr)
					if name == ".." then
						return true
					end

					-- Check if the file is .git directory
					if name == ".git" then
						return true
					end

					return false
				end,
				-- Customize the highlight group for the file name
				highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
					-- Skip parent directory entry
					if entry.name == ".." then
						return nil
					end

					if git_ignored_files[entry.name] or git_ignored_dirs[entry.name] then
						return "OilGitIgnored" -- Gray out git-ignored files
					end

					-- Get the current directory being viewed in Oil
					local current_dir = require("oil").get_current_dir()
					if not current_dir then
						return nil
					end

					-- Check if any parent directory is git-ignored
					local path_to_check = vim.fn.fnamemodify(vim.fs.normalize(current_dir .. entry.name), ":.")

					-- Check all parent directories
					local path_parts = {}
					for part in vim.gsplit(path_to_check, "/", { plain = true }) do
						table.insert(path_parts, part)
						local partial_path = table.concat(path_parts, "/")
						if git_ignored_full_paths[partial_path] then
							return "OilGitIgnored"
						end
					end

					return nil -- Use default highlighting for non-ignored files
				end,
			},
			keymaps = {
				["gd"] = {
					desc = "Toggle file detail view",
					callback = function()
						detail = not detail
						if detail then
							require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
						else
							require("oil").set_columns({ "icon" })
						end
					end,
				},
			},
		},
		config = function(_, opts)
			require("oil").setup(opts)

			local refresh = require("oil.actions").refresh
			local original_refresh = refresh.callback
			refresh.callback = function(...)
				-- Refresh the list of git ignored files
				git_ignored_files, git_ignored_dirs, git_ignored_full_paths = get_git_ignored_files()

				-- Call the original refresh function
				original_refresh(...)
			end

			-- Create custom highlight group for git ignored files
			vim.api.nvim_set_hl(0, "OilGitIgnored", { link = "Comment" })

			-- Reset the hidden files highlight to make them appear normal
			vim.api.nvim_set_hl(0, "OilFileHidden", {
				link = "OilFile",
			}) -- For hidden files
			vim.api.nvim_set_hl(0, "OilDirHidden", {
				link = "Directory",
			}) -- For hidden files
		end,
		keys = {
			-- Open the current file's directory in Oil
			{
				"-",
				function()
					require("oil").open()
				end,
				desc = "Open Oil",
			},
			-- Open the current working directory in Oil
			{
				"_",
				function()
					require("oil").open(vim.fn.getcwd())
				end,
			},
		},
	},
}
