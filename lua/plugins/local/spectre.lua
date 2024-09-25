return {
  {
    "nvim-pack/nvim-spectre",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("spectre").setup()
    end,

    keys = {
      {
        "<leader>SS",
        function()
          require("spectre").toggle()
        end,
        mode = "n",
        desc = "Toggle Spectre",
      },
      {
        "<leader>Sw",
        function()
          require("spectre").open_visual({ select_word = true })
        end,
        mode = "n",
        desc = "Search current word",
      },
      {
        "<leader>Sw",
        function()
          require("spectre").open_visual()
        end,
        mode = "v",
        desc = "Search current word",
      },
      {
        "<leader>Sp",
        function()
          require("spectre").open_file_search({ select_word = true })
        end,
        mode = "n",
        desc = "Search on current file",
      },
    },
  },
}
