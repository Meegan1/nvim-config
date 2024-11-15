return {
  {
    "nvim-pack/nvim-spectre",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = function()
      local os = vim.uv.os_uname().sysname
      local replace_engine = os == "Darwin"
          and {
            ["sed"] = {
              cmd = "sed",
              args = {
                "-i",
                "",
                "-E",
              },
            },
          }
          or nil

      return {
        replace_engine = replace_engine,
      }
    end,

    config = function(_, opts)
      require("spectre").setup(opts)
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
