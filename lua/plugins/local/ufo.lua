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
      vim.opt.foldcolumn = "0"
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldenable = true

      vim.keymap.set("n", "zO", require("ufo").openAllFolds)
      vim.keymap.set("n", "zC", require("ufo").closeAllFolds)

      require("ufo").setup()
    end,
  },
}
