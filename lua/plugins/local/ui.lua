return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      {
        "kyazdani42/nvim-web-devicons"
      }
    },
    opts = {
      filters = {
        dotfiles = false,
      },
      tab = {
        sync = {
          open = true,
          close = true,
        }
      },
      on_attach = on_nvim_tree_attach,
    },
  },
  {
    "romgrk/barbar.nvim",
    opts = {
      sidebar_filetypes = {
        NvimTree = true
      }
    },
    dependencies = {
      {
        "kyazdani42/nvim-web-devicons"
      },
      {
        'lewis6991/gitsigns.nvim'
      }
    }
  },
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>ue",
        function()
          require("edgy").toggle()
        end,
        desc = "Edgy Toggle",
      },
      {
        "<leader>uE",
        function()
          require("edgy").select()
        end,
        desc = "Edgy Select Window",
      },
    },
    opts = function()
      local opts = {
        wo = {
          spell = false,
        },
        animate = {
          enabled = false,
        },
        bottom = {
          {
            ft = "toggleterm",
            size = { height = 0.4 },
            filter = function(_, win)
              return vim.api.nvim_win_get_config(win).relative == ""
            end,
          },
          "Trouble",
          {
            ft = "qf",
            title = "QuickFix",
          },
          {
            ft = "help",
            size = { height = 20 },
            -- don't open help files in edgy that we're editing
            filter = function(buf)
              return vim.bo[buf].buftype == "help"
            end,
          },
        },
        keys = {
          -- increase width
          ["<c-Right>"] = function(win)
            win:resize("width", 2)
          end,
          -- decrease width
          ["<c-Left>"] = function(win)
            win:resize("width", -2)
          end,
          -- increase height
          ["<c-Up>"] = function(win)
            win:resize("height", 2)
          end,
          -- decrease height
          ["<c-Down>"] = function(win)
            win:resize("height", -2)
          end,
        },
      }
      return opts
    end,
  },
  -- Toggle term
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = 20,
      open_mapping = [[<D-j>]],
      dir = "git_dir",
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      close_on_exit = true,
      shell = vim.o.shell,
    },
    keys = {
      {
        "<D-j>",
        "<cmd>:ToggleTerm<cr>",
        desc = "Toggle Term",
      },
      {
        "<leader>ft",
        "<cmd>:ToggleTerm<cr>",
        desc = "Find Toggle Term",
      },
    },
  },
}
