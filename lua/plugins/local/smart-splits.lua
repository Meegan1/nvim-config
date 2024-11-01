return {
  {
    "mrjones2014/smart-splits.nvim",
    keys = {
      {
        "<C-w>h",
        function()
          require("smart-splits").move_cursor_left()
        end,
        desc = "Move left",
      },
      {
        "<C-w>l",
        function()
          require("smart-splits").move_cursor_right()
        end,
        desc = "Move right",
      },
      {
        "<C-w>k",
        function()
          require("smart-splits").move_cursor_up()
        end,
        desc = "Move up",
      },
      {
        "<C-w>j",
        function()
          require("smart-splits").move_cursor_down()
        end,
        desc = "Move down",
      },
      {
        "<A-S-w>h",
        function()
          require("smart-splits").swap_buf_left()
        end,
        desc = "Swap buffer left",
      },
      {
        "<A-S-w>l",
        function()
          require("smart-splits").swap_buf_right()
        end,
        desc = "Swap buffer right",
      },
      {
        "<A-S-w>k",
        function()
          require("smart-splits").swap_buf_up()
        end,
        desc = "Swap buffer up",
      },
      {
        "<A-S-w>j",
        function()
          require("smart-splits").swap_buf_down()
        end,
        desc = "Swap buffer down",
      },
    },
  },
}
