return {
  {
    "nvimtools/hydra.nvim",
    dependencies = {
      "folke/edgy.nvim",
      "mrjones2014/smart-splits.nvim",
    },

    config = function()
      local Hydra = require("hydra")
      local edgy = require("edgy")
      local smart_splits = require("smart-splits")

      Hydra({
        name = "Resize windows",
        mode = "n",
        body = "<A-w>",
        hint = [[Resize windows]],

        heads = {
          {
            "h",
            function()
              local edgy_win = edgy.get_win()
              if edgy_win == nil then
                smart_splits.resize_left()
              else
                edgy.get_win():resize("width", -2)
              end
            end,
            { desc = "Resize left" },
          },
          {
            "l",
            function()
              local edgy_win = edgy.get_win()
              if edgy_win == nil then
                smart_splits.resize_right()
              else
                edgy.get_win():resize("width", 2)
              end
            end,
            { desc = "Resize right" },
          },
          {
            "k",
            function()
              local edgy_win = edgy.get_win()
              if edgy_win == nil then
                smart_splits.resize_up()
              else
                edgy.get_win():resize("height", 2)
              end
            end,
            { desc = "Resize up" },
          },
          {
            "j",
            function()
              local edgy_win = edgy.get_win()
              if edgy_win == nil then
                smart_splits.resize_down()
              else
                edgy.get_win():resize("height", -2)
              end
            end,
            { desc = "Resize down" },
          },
        },
      })

      Hydra({
        "Organize buffers",
        mode = "n",
        body = "<A-b>",
        hint = [[Organize buffers]],
        heads = {
          {
            "h",
            function()
              vim.cmd("BufferMovePrevious")
            end,
            {
              desc = "Move buffer left",
            },
          },
          {
            "l",
            function()
              vim.cmd("BufferMoveNext")
            end,
            {
              desc = "Move buffer right",
            },
          },
          {
            "d",
            function()
              vim.cmd("BufferClose")
            end,
            {
              desc = "Close buffer",
            },
          },
          {
            "D",
            function()
              vim.cmd("BufferCloseAllButVisible")
            end,
            {
              desc = "Close all buffers but visible",
            },
          },
        },
        config = {
          on_key = function()
            -- Preserve animation
            vim.wait(200, function()
              vim.cmd("redraw")
            end, 30, false)
          end,
        },
      })
    end,
  },
}
