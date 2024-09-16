return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",

      "marilari88/neotest-vitest",
    },

    opts = function()
      return {
        adapters = {
          require("neotest-vitest"),
        },
      }
    end,
    config = function(_, opts)
      require("neotest").setup(opts)
    end,
  },
}
