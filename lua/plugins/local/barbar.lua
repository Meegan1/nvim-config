return {
  {
    "romgrk/barbar.nvim",
    event = "BufRead",
    opts = {
      sidebar_filetypes = {
        ["neo-tree"] = true,
      },
      exclude_ft = {
        "codecompanion",
        "qf",
        "spectre_panel",
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
    keys = {
      {
        "<leader>s",
        function()
          vim.cmd("BufferPick")
        end,
      },
    },
  },
}
