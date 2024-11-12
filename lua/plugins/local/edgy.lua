return {
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = function()
      local opts = {
        wo = {
          spell = false,
        },
        animate = {
          enabled = false,
        },
        options = {
          left = {
            wo = {
              winbar = false,
            },
          },
        },
        bottom = {
          {
            title = "Terminal",
            ft = "toggleterm",
            size = { height = 0.4 },
            filter = function(_, win)
              return vim.api.nvim_win_get_config(win).relative == ""
            end,
            pinned = true,
          },
          "Trouble",
          {
            ft = "noice",
            size = { height = 0.4 },
            filter = function(buf, win)
              return vim.api.nvim_win_get_config(win).relative == ""
            end,
          },
          {
            ft = "qf",
            title = "QuickFix",
          },
          {
            ft = "help",
            size = { height = 20 },
            -- don't open help files in edgy that we're editing
            filter = function(buf)
              return vim.bo[buf].buftype == "help"
            end,
          },
        },
        left = {
          {
            ft = "neo-tree",
            pinned = true,
          },
        },
        right = {
          {
            title = "Copilot",
            ft = "codecompanion",
            size = { width = 0.4 },
          },
        },
      }
      return opts
    end,
  },
}
