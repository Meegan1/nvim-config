return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = true,
	},
	{
		"nvimtools/none-ls.nvim",
	},
	{
		"jay-babu/mason-null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim",
		},
		config = function()
			require("mason-null-ls").setup({
				ensure_installed = {
					"stylua",
					"prettierd",
					"dprint",
				},
			})
		end,
	},
	{ "williamboman/mason-lspconfig.nvim" },
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		lazy = true,
		config = false,
		init = function()
			-- Disable automatic setup, we are doing it manually
			vim.g.lsp_zero_extend_cmp = 0
			vim.g.lsp_zero_extend_lspconfig = 0
		end,
	},
	{
		"neovim/nvim-lspconfig",
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "williamboman/mason-lspconfig.nvim" },
			{ "folke/which-key.nvim" },
		},
		config = function()
			-- This is where all the LSP shenanigans will live
			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_lspconfig()
			local whichkey = require("which-key")

			vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Open LSP diagnostic float" })
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Goto previous LSP Diagnostic" })
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Goto next LSP Diagnostic" })

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local bufnr = event.buf

					vim.keymap.set("n", "gh", vim.lsp.buf.hover, { desc = "Show LSP Info", buffer = bufnr })
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Open LSP Definition", buffer = bufnr })
					vim.keymap.set(
						"n",
						"gi",
						vim.lsp.buf.implementation,
						{ desc = "Open LSP Implementation", buffer = bufnr }
					)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Show LSP References", buffer = bufnr })
					vim.keymap.set(
						"n",
						"go",
						vim.lsp.buf.type_definition,
						{ desc = "Open Type Definition", buffer = bufnr }
					)
					vim.keymap.set(
						"n",
						"gs",
						vim.lsp.buf.signature_help,
						{ desc = "Open Signature Help", buffer = bufnr }
					)
				end,

				-- bind <Esc> to close the hover buffer
				vim.keymap.set("n", "<Esc>", function()
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						local config = vim.api.nvim_win_get_config(win)
						if config.relative ~= "" then
							vim.api.nvim_win_close(win, false)
						end
					end
				end, { buffer = bufnr, desc = "Close hover doc" }),
			})

			local ensure_installed = {
				"lua_ls",
				"ts_ls",
				"intelephense",
				"tailwindcss",
				"yamlls",
				"jsonls",
				"shopify_theme_ls",
				"twiggy_language_server",
			}

			-- Setup nixd for nix files if nixd is installed
			if vim.fn.executable("nixd") == 1 then
				require("lspconfig").nixd.setup({})
			end

			-- if helm is installed, add helm_ls to ensure_installed
			if vim.fn.has("helm") == 1 then
				table.insert(ensure_installed, "helm_ls")
			end

			require("mason-lspconfig").setup({
				-- LSP servers to ensure are installed
				ensure_installed = ensure_installed,
				handlers = {
					-- this first function is the "default handler"
					-- it applies to every language server without a "custom handler"
					function(server_name)
						local capabilities = vim.lsp.protocol.make_client_capabilities()
						capabilities.textDocument.foldingRange = {
							dynamicRegistration = false,
							lineFoldingOnly = true,
						}

						local opts = {
							capabilities = capabilities,
							on_attach = function(client, bufnr)
								-- inlay hints
								if vim.fn.has("nvim-0.10") == 1 then
									vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
								end
							end,
							root_dir = require("lspconfig/util").root_pattern(".git", "package.json") or vim.loop.cwd(),
						}

						if server_name == "ts_ls" then
							local inlayHints = {
								includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayVariableTypeHints = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHintsWhenTypeMatchesName = false,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = false,
								includeInlayEnumMemberValueHints = true,
							}

							opts = vim.tbl_extend("force", opts, {
								settings = {
									typescript = {
										inlayHints = inlayHints,
									},
									javascript = {
										inlayHints = inlayHints,
									},
								},
							})
							return -- skip ts_ls
						end

						if server_name == "yamlls" then
							opts = vim.tbl_extend("force", opts, {
								settings = {
									yaml = {
										schemas = {
											kubernetes = "templates/**",
											["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
											["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
											["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
											["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
											["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
										},
									},
								},
							})
						end

						if server_name == "jsonls" then
							opts = vim.tbl_extend("force", opts, {
								settings = {
									json = {
										schemas = require("schemastore").json.schemas(),
										validate = { enable = true },
									},
								},
							})
						end

						if server_name == "helm_ls" then
							opts = vim.tbl_extend("force", opts, {
								settings = {
									["helm-ls"] = {
										yamlls = {
											path = "yaml-language-server",
										},
									},
								},
							})
						end

						if server_name == "twiggy_language_server" then
							opts = vim.tbl_extend("force", opts, {
								maxFileSize = 10000000,
								settings = {
									twiggy = {
										autoInsertSpaces = true,
										inlayHints = {
											macro = true,
											block = true,
											macroArguments = true,
										},
										phpExecutable = "php",
										symfonyConsolePath = "./bin/console",
										vanillaTwigEnvironmentPath = "",
										framework = "craft",
										diagnostics = {
											twigCsFixer = true,
										},
									},
								},
							})
						end

						require("lspconfig")[server_name].setup(opts)
					end,
				},
			})
		end,
	},
	{ "Bilal2453/luvit-meta", lazy = true },
	{
		"towolf/vim-helm",
	},
}
