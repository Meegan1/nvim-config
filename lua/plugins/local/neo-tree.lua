return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		opts = {
			open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "edgy" },
			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					never_show = {
						".DS_Store",
						".git",
					},
				},
			},
			window = {
				mappings = {
					["l"] = "open",
					["o"] = "toggle_node",
					["oc"] = "noop",
					["od"] = "noop",
					["og"] = "noop",
					["om"] = "noop",
					["on"] = "noop",
					["os"] = "noop",
					["ot"] = "noop",
					["s"] = "noop",
					["S"] = "open_vsplit",
					["T"] = {
						function(state)
							local node = state.tree:get_node()
							local path = node.path

							-- check if path is a directory or file
							if vim.fn.isdirectory(path) == 0 then
								path = vim.fn.fnamemodify(path, ":h")
							end

							local Terminal = require("toggleterm.terminal").Terminal
							Terminal:new({ dir = path, cmd = "zsh" }):toggle()
						end,
						desc = "Open in a new terminal",
						nowait = true,
					},
				},
			},
			-- file nesting
			nesting_rules = {
				["js"] = {
					"test.js",
					"spec.js",
					"stories.js",
				},
				["ts"] = {
					"test.ts",
					"spec.ts",
					"stories.ts",
				},
				["jsx"] = {
					"test.jsx",
					"spec.jsx",
					"stories.jsx",
				},
				["tsx"] = {
					"test.tsx",
					"spec.tsx",
					"stories.tsx",
				},
				["package.json"] = {
					pattern = "^package%.json$", -- <-- Lua pattern
					files = { "package-lock.json", "yarn*" }, -- <-- glob pattern
				},
			},
			-- lsp
			lsp = {
				hover = {
					silent = true,
				},
			},
		},

		config = function(_, opts)
			require("neo-tree").setup(opts)

			local neo_tree = require("neo-tree")

			-- bind <C-b> to toggle neotree
			vim.keymap.set({ "n", "i", "v" }, "<C-b>", function()
				vim.cmd("Neotree toggle")
			end)

			-- bind <C-A-F> to find file in neotree
			vim.keymap.set({ "n", "i", "v" }, "<C-A-f>", function()
				vim.cmd("Neotree reveal")
			end)
		end,
	},
}
