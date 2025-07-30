return {
	{
		"pmizio/typescript-tools.nvim",
		requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			return {

				capabilities = capabilities,
				on_attach = function(client, bufnr)
					-- inlay hints
					if vim.fn.has("nvim-0.10") == 1 then
						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end
				end,
				settings = {
					tsserver_file_preferences = {
						includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayVariableTypeHints = false,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHintsWhenTypeMatchesName = false,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = false,
						includeInlayEnumMemberValueHints = true,
					},
				},
			}
		end,
		config = function(_, opts)
			require("typescript-tools").setup(opts)

			-- Remove unused imports
			vim.keymap.set("n", "<leader>ir", function()
				require("typescript-tools.api").remove_unused_imports(false)
			end, {
				desc = "Remove imports",
			})

			-- Fix all missing imports
			vim.keymap.set("n", "<leader>if", function()
				require("typescript-tools.api").add_missing_imports(false)
			end, {
				desc = "Fix imports",
			})
		end,
	},
}
