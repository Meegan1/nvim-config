return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      -- Treesitter plugins to ensure are installed
      ensure_installed = {
        "typescript",
        "javascript",
        "tsx",
        "html",
        "lua",
        "json",
        "yaml",
        "css",
        "scss",
        "graphql",
        "bash",
        "markdown",
        "markdown_inline",
        "regex",
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    dir = vim.fn.stdpath("config") .. "/plugins/nvim-ts-autotag",
    name = "nvim-ts-autotag",
    dependencies = {
      'nvim-treesitter/nvim-treesitter'
    },
    opts = {},
    config = function(_, opts)
      require('nvim-ts-autotag').setup(opts)
    end
  },
}
