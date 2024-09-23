return {
  dir = vim.fn.stdpath("config") .. "/plugins/yaml-schema-crds",
  name = "yaml-schema-crds",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("yaml-schema-crds").setup()
  end,
}
