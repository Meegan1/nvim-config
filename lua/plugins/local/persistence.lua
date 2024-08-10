return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",                               -- this will only start session saving when an actual file was opened
    opts = {
      dir = vim.fn.stdpath("state") .. "/my-sessions/", -- directory where session files are saved
    },
    keys = {
      { "<leader>qs", function() require("persistence").save() end,                desc = "Save session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
      { "<leader>qS", function() require("persistence").select() end,              desc = "Select session to restore" },
      { "<leader>qd", function() require("persistence").stop() end,                desc = "Stop persistence" },
    },
  },
}
