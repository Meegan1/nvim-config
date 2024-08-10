return {
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
}
