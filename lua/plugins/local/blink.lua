return {
	{
		"saghen/blink.cmp",
		dependencies = {
			{ "L3MON4D3/LuaSnip", version = "v2.x" },
		},

		-- use a release tag to download pre-built binaries
		version = "*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		opts = function()
			---@module 'blink.cmp'
			---@type blink.cmp.Config
			local config = {
				snippets = {
					preset = "luasnip",
				},

				appearance = {
					-- Sets the fallback highlight groups to nvim-cmp's highlight groups
					-- Useful for when your theme doesn't support blink.cmp
					-- Will be removed in a future release
					use_nvim_cmp_as_default = false,
					-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
					-- Adjusts spacing to ensure icons are aligned
					nerd_font_variant = "mono",
				},

				-- Default list of enabled providers defined so that you can extend it
				-- elsewhere in your config, without redefining it, due to `opts_extend`
				sources = {
					default = { "lsp", "dadbod", "path", "buffer", "codecompanion", "snippets" },
				},

				completion = {
					menu = {
						border = "rounded",

						-- nvim-cmp style menu
						draw = {
							columns = {
								{ "label", "label_description", gap = 1 },
								{ "kind_icon", gap = 1, "kind" },
							},
						},
					},

					documentation = {
						auto_show = true,
						auto_show_delay_ms = 500,
					},

					list = {
						selection = {
							preselect = function(ctx)
								return ctx.mode ~= "cmdline"
							end,
						},
					},
				},

				keymap = {
					-- set to 'none' to disable the 'default' preset
					preset = "none",

					["<C-space>"] = { "show", "hide" },
					["<C-e>"] = { "hide" },
					["<CR>"] = { "accept", "fallback" },

					["<C-p>"] = { "select_prev", "fallback" },
					["<C-n>"] = { "select_next", "fallback" },

					["<Up>"] = { "select_prev", "fallback" },
					["<Down>"] = { "select_next", "fallback" },

					["<C-b>"] = { "scroll_documentation_up", "fallback" },
					["<C-f>"] = { "scroll_documentation_down", "fallback" },

					["<Tab>"] = {
						function(cmp)
							-- if in command mode, select next item
							if vim.api.nvim_get_mode().mode == "c" then
								cmp.select_next()
								return true
							end
						end,
						"fallback",
					},

					["<Char-1106366>"] = {
						function(cmp)
							-- if in command mode, select previous item
							if vim.api.nvim_get_mode().mode == "c" then
								cmp.select_prev()
								return true
							end
						end,
						"fallback",
					},
					["<S-Tab>"] = {
						function(cmp)
							-- if in command mode, select previous item
							if vim.api.nvim_get_mode().mode == "c" then
								cmp.select_prev()
								return true
							end
						end,
						"fallback",
					},
				},
			}

			-- Check if running in WSL2
			-- see https://github.com/Saghen/blink.cmp/issues/795
			if os.getenv("WSL_INTEROP") then
				-- Add provider configuration to disable completion in shell command mode
				config.sources.providers = {
					cmdline = {
						-- ignores cmdline completions when executing shell commands
						enabled = function()
							return vim.fn.getcmdtype() ~= ":" or not vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!")
						end,
					},
				}
			end

			return config
		end,
		opts_extend = { "sources.default" },
	},
}
