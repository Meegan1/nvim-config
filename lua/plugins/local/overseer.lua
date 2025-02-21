return {
	{
		"stevearc/overseer.nvim",
		opts = {},
		config = function(_, opts)
			require("overseer").setup(opts)

			local get_sidebar = function()
				return require("overseer.task_list.sidebar").get_or_create()
			end

			local jump_task = function(num)
				local sidebar = get_sidebar()
				local focused_task = sidebar.focused_task_id
				local task_lines = sidebar.task_lines

				-- loop over the task lines to find the focused task
				for i, line in ipairs(task_lines) do
					if line[2].id == focused_task then
						local target_index

						-- calculate target index with wrap-around
						if i + num > #task_lines then
							target_index = 1
						elseif i + num < 1 then
							target_index = #task_lines
						else
							target_index = i + num
						end

						sidebar:focus_task_id(task_lines[target_index][2].id)
						break
					end
				end
			end

			-- Add keymap <leader>oo to toggle the overseer window
			vim.keymap.set("n", "<leader>oo", function()
				require("overseer").toggle()
			end, { noremap = true, silent = true, desc = "Open overseer" })

			-- Add keymap <leader>or to run a command in the overseer window
			vim.keymap.set("n", "<leader>or", function()
				vim.cmd("OverseerRun")
			end, { noremap = true, silent = true, desc = "Run command in overseer" })

			-- Jump to the next task
			vim.keymap.set("n", "<leader>on", function()
				jump_task(1)
			end, { noremap = true, silent = true, desc = "Jump to the next task" })
			vim.keymap.set("n", "]o", function()
				jump_task(1)
			end, { noremap = true, silent = true, desc = "Jump to the next task" })

			-- Jump to the previous task
			vim.keymap.set("n", "<leader>op", function()
				jump_task(-1)
			end, { noremap = true, silent = true, desc = "Jump to the previous task" })
			vim.keymap.set("n", "[o", function()
				jump_task(-1)
			end, { noremap = true, silent = true, desc = "Jump to the previous task" })

			-- Restart the task
			vim.keymap.set("n", "<leader>oR", function()
				get_sidebar():run_action("restart")
			end, { noremap = true, silent = true, desc = "Restart the task" })
		end,
	},
}
