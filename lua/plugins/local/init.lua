return {
  { "EdenEast/nightfox.nvim", tag = "v1.0.0" },
  -- Configure LazyVim to load nightfox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nightfox",
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
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
    dependencies = {
      {
        "kyazdani42/nvim-web-devicons"
      }
    }
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
    'markonm/traces.vim'
  },
}
