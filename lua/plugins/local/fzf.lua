return {
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			keymap = {
				-- Customize key mappings in fzf window
				build_in = {
					["<C-.>"] = "accept",
					["l"] = "accept",
				},
			},
			-- winopts = {
			-- 	-- Window layout options
			-- 	-- height = 0.85,
			-- 	-- width = 0.80,
			-- 	-- preview = {
			-- 	-- 	hidden = "hidden",
			-- 	-- },
			-- },
			ui_select = function(fzf_opts, items)
				local opts = vim.tbl_deep_extend("force", fzf_opts, {
					prompt = " ",
					winopts = {
						title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
						title_pos = "center",
					},
				}, fzf_opts.kind == "codeaction" and {
					winopts = {
						layout = "vertical",
						-- height is number of items minus 15 lines for the preview, with a max of 80% screen height
						height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 2) + 0.5) + 16,
						width = 0.5,
						preview = {
							layout = "vertical",
							vertical = "up:15,border-top",
						},
					},
				} or {
					winopts = {
						width = 0.5,
						-- height is number of items, with a max of 80% screen height
						height = math.floor(math.min(vim.o.lines * 0.8, #items + 2) + 0.5),
					},
				})

				return opts
			end,

			lsp = {
				symbols = {
					symbol_hl = function(s)
						return "TroubleIcon" .. s
					end,
					symbol_fmt = function(s)
						return s:lower() .. "\t"
					end,
					child_prefix = false,
				},
			},
		},
		config = function(_, opts)
			local fzf = require("fzf-lua")

			fzf.setup(opts)
			fzf.register_ui_select(opts.ui_select)

			local config = fzf.config

			-- Quickfix
			config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
			config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
			config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
			config.defaults.keymap.fzf["ctrl-x"] = "jump"
			config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
			config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
			config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
			config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"

			-- Files with hidden files and ignore .git
			vim.keymap.set({ "n", "i", "v" }, "<C-p>", function()
				require("fzf-lua").files({
					hidden = true,
					fd_opts = "--type f --hidden --exclude .git",
				})
			end)

			-- Commands
			vim.keymap.set({ "n", "i", "v" }, "<C-S-P>", function()
				require("fzf-lua").commands()
			end)

			-- Live grep with hidden files
			vim.keymap.set("n", "<C-S-F>", function()
				require("fzf-lua").live_grep({
					hidden = true,
					no_ignore = true,
				})
			end)

			-- LSP workspace symbols
			vim.keymap.set("n", "<C-t>", function()
				require("fzf-lua").lsp_workspace_symbols()
			end)

			-- Undo history (built into fzf-lua)
			vim.keymap.set("n", "<leader>u", function()
				require("modules.fzf.undo").undo()
			end, { desc = "undo history" })

			vim.keymap.set({ "n", "i", "v" }, "<C-.>", function()
				vim.lsp.buf.code_action()
			end)
		end,
	},
}
