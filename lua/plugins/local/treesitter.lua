return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      -- Treesitter plugins to ensure are installed
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
