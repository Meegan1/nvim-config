return {
  {
    "kevinhwang91/promise-async",
  },
  {
    "kevinhwang91/nvim-ufo",
    requires = {
      "kevinhwang91/promise-async",
      "neovim/nvim-lspconfig",
    },
    config = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      vim.keymap.set("n", "zO", require("ufo").openAllFolds)
      vim.keymap.set("n", "zC", require("ufo").closeAllFolds)

      require("ufo").setup()
    end,
  },
}
