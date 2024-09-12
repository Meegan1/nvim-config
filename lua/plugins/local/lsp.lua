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
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      -- Define your formatters
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
      },
      -- Set default options
      default_format_opts = {
        lsp_format = "fallback",
      },
      -- Set up format-on-save
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        return { timeout_ms = 1000 }
      end,
    },
    ---@param opts ConformOpts
    config = function(_, opts)
      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = "Disable autoformat-on-save",
        bang = true,
      })

      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = "Re-enable autoformat-on-save",
      })

      vim.api.nvim_create_user_command("SaveWithoutFormatting", function()
        vim.cmd("FormatDisable")
        vim.cmd("w")
        vim.cmd("FormatEnable")
      end, {
        desc = "Save without formatting",
      })

      require("conform").setup(opts)
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
      { "hrsh7th/cmp-nvim-lsp" },
      { "williamboman/mason-lspconfig.nvim" },
    },
    config = function()
      -- This is where all the LSP shenanigans will live
      local lsp_zero = require("lsp-zero")
      lsp_zero.extend_lspconfig()

      --- if you want to know more about lsp-zero and mason.nvim
      --- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
      lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp_zero.default_keymaps({ buffer = bufnr })
        lsp_zero.buffer_autoformat()

        -- bind gh to vim.lsp.buf.hover()
        vim.keymap.set("n", "gh", function()
          vim.lsp.buf.hover()
        end, { buffer = bufnr, desc = "Show hover doc" })

        -- bind <Esc> to close the hover buffer
        vim.keymap.set("n", "<Esc>", function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local config = vim.api.nvim_win_get_config(win)
            if config.relative ~= "" then
              vim.api.nvim_win_close(win, false)
            end
          end
        end, { buffer = bufnr, desc = "Close hover doc" })
      end)

      local ensure_installed = {
        "lua_ls",
        "ts_ls",
        "intelephense",
        "tailwindcss",
      }

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

            require("lspconfig")[server_name].setup(opts)
          end,
        },
      })
    end,
  },
  {
    "luckasRanarison/tailwind-tools.nvim",
    name = "tailwind-tools",
    build = ":UpdateRemotePlugins",
    branch = "master",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      server = {
        settings = {
          settings = {
            experimental = {
              classRegex = {
                "\\/\\*\\s*tw\\s*\\*\\/\\s*[`'\"](.*)[`'\"];?",
                { "(?:twMerge|twJoin)\\(([^\\);]*)[\\);]", "[`'\"]([^'\"`,;]*)[`'\"]" },
                "twc\\`(.*)\\`;?",
                { "cva\\(([^)]*)\\)",                      "[\"'`]([^\"'`]*).*?[\"'`]" },
                { "cx\\(([^)]*)\\)",                       "(?:'|\"|`)([^']*)(?:'|\"|`)" },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      require("tailwind-tools").setup(opts)
    end,
  },
  { "hrsh7th/cmp-nvim-lsp" },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true },
  {
    "onsails/lspkind.nvim",
  },
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "windwp/nvim-autopairs",
      "luckasRanarison/tailwind-tools.nvim",
    },
    config = function()
      -- Here is where you configure the autocompletion settings.
      local lsp_zero = require("lsp-zero")
      lsp_zero.extend_cmp()

      -- And you can configure cmp even more, if you want to.
      local cmp = require("cmp")
      local cmp_action = lsp_zero.cmp_action()

      -- Autopairs when selecting a autocompletion
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      cmp.setup({
        auto_brackets = {}, -- configure any filetype to auto add brackets
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        -- formatting = lsp_zero.cmp_format({ details = true }),
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-f>"] = cmp_action.luasnip_jump_forward(),
          ["<C-b>"] = cmp_action.luasnip_jump_backward(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<S-Esc>"] = cmp.mapping.close(),

          ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = "select" }),
          ["<C-j>"] = cmp.mapping.select_next_item({ behavior = "select" }),
          ["<C-l>"] = cmp.mapping.confirm({ select = true }),
        }),
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer" },
          {
            name = "lazydev",
            group_index = 0,
          },
        }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        -- here is where the change happens
        format = function(entry, item)
          local menu_icon = {
            nvim_lsp = "λ",
            luasnip = "⋗",
            buffer = "Ω",
            path = "🖫",
            nvim_lua = "Π",
          }

          item.menu = menu_icon[entry.source.name]
          return item
        end,
        formatting = {
          format = require("lspkind").cmp_format({
            before = require("tailwind-tools.cmp").lspkind_format,
          }),
        },
      })
    end,
  },
  { "L3MON4D3/LuaSnip" },
  {
    "towolf/vim-helm",
  },
}
