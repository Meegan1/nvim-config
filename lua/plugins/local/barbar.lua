return {
  {
    "romgrk/barbar.nvim",
    event = "BufRead",
    opts = {
      sidebar_filetypes = {
        ["neo-tree"] = true,
      },
    },
    dependencies = {
      {
        "kyazdani42/nvim-web-devicons",
      },
      {
        "lewis6991/gitsigns.nvim",
      },
    },
  },
}
