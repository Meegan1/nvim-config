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
        "<A-b>h",
        function()
          vim.cmd("BufferMovePrevious")
        end,
        desc = "Move buffer left",
      },
      {
        "<A-b>l",
        function()
          vim.cmd("BufferMoveNext")
        end,
        desc = "Move buffer right",
      },
      {
        "<A-b>d",
        function()
          vim.cmd("BufferClose")
        end,
        desc = "Close buffer",
      },
      {
        "<A-b>D",
        function()
          vim.cmd("BufferCloseAllButVisible")
        end,
        desc = "Close all buffers but visible",
      },
      {
        "<leader>s",
        function()
          vim.cmd("BufferPick")
        end,
      },
    },
  },
}
