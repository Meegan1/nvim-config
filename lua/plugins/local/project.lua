return {
	{
		"ahmedkhalf/project.nvim",
		requires = {
			"ibhagwan/fzf-lua",
		},
		enabled = false,
		options = {
			patterns = { ".git" },
		},
		config = function(_, opts)
			require("project_nvim").setup(opts)

			local fzf_lua = require("fzf-lua")
			vim.keymap.set("n", "<leader>fp", function()
				local history = require("project_nvim.utils.history")
				fzf_lua.fzf_exec(function(cb)
					local results = history.get_recent_projects()
					for _, e in ipairs(results) do
						cb(e)
					end
					cb()
				end, {
					actions = {
						["default"] = {
							function(selected)
								fzf_lua.files({ cwd = selected[1] })
							end,
						},
						["ctrl-d"] = {
							function(selected)
								history.delete_project({ value = selected[1] })
							end,
							fzf_lua.actions.resume,
						},
					},
				})
			end)
		end,
	},
}
