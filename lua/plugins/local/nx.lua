return {
  "Sewb21/nx.nvim",
  config = true,
  opts = {
    nx_cmd_root = "bun nx",
  },
  keys = {
    { "<leader>nx", "<cmd>Telescope nx actions<CR>",    desc = "nx actions" },
    { "<leader>ng", "<cmd>Telescope nx generators<CR>", desc = "nx generators" },
  },
}
