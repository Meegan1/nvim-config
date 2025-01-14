return {
	{
		"pwntester/octo.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"ibhagwan/fzf-lua",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("octo").setup()
			local Job = require("plenary.job")

			vim.api.nvim_create_user_command("CheckoutIssue", function(opts)
				-- get the issue id from argument or popup
				local issue_id = opts.args ~= "" and opts.args or vim.fn.input("Issue ID: ")

				-- check if issue id is not empty
				if issue_id ~= "" then
					-- Notify the user that the branch creation is starting
					vim.notify("Creating branch for issue " .. issue_id, "info", { title = "Octo" })

					-- run gh issue develop <issue_id> --checkout
					Job:new({
						command = "gh",
						args = { "issue", "develop", issue_id, "--checkout", "--base", "main" },
						on_exit = function(j, return_val)
							if return_val == 0 then
								vim.notify("Checked out issue", "info", { title = "Octo" })
							else
								vim.notify(vim.inspect(j:stderr_result()), "error", { title = "Octo" })
								vim.notify("Failed to checkout issue", "error", { title = "Octo" })
							end
						end,
					}):start()
				end
			end, {
				desc = "Checkout an issue",
				nargs = "?",
			})
		end,
		cond = function()
			-- check if gh is installed
			return vim.fn.executable("gh") == 1
		end,
	},
}
