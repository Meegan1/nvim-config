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

      local clear_query = function()
        -- Set the state to the default
        require("spectre.state").query = {
          search_query = "",
          replace_query = "",
          path = "",
          is_file = false,
        }
        require("spectre").close()
        require("spectre").open()
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "spectre_panel",
        callback = function()
          vim.keymap.set("n", "q", function()
            require("spectre").close()
          end, { buffer = true, silent = true, desc = "Close spectre window" })

          vim.keymap.set("n", "Q", function()
            clear_query()
            require("spectre").close()
          end, { buffer = true, silent = true, desc = "Close spectre window and clear query" })

          vim.keymap.set("n", "<C-c>", function()
            clear_query()
          end, { buffer = true, silent = true, desc = "Clear query" })
        end,
      })
    end,

    keys = {
      {
        "<leader>SS",
        function()
          local spectre_state = require("spectre.actions").get_state()

          local path = spectre_state.query.path
          local replace_query = spectre_state.query.replace_query
          local search_query = spectre_state.query.search_query

          require("spectre").toggle({
            search_text = search_query,
            replace_text = replace_query,
            path = path,
          })
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
