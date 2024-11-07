return {
  {
    "Bekaboo/dropbar.nvim",
    -- optional, but required for fuzzy finder support
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function(_, config)
      local utils = require("dropbar.utils")
      local api = require("dropbar.api")

      require("dropbar").setup({

        bar = {
          sources = function(buf, _)
            local sources = require("dropbar.sources")

            return {
              sources.path,
            }
          end,
        },
        menu = {
          preview = false,
          keymaps = {
            ["l"] = function()
              local menu = utils.menu.get_current()
              if not menu then
                return
              end
              local cursor = vim.api.nvim_win_get_cursor(menu.win)
              local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
              if component then
                menu:click_on(component, nil, 1, "l")
              end
            end,
            ["h"] = "<C-w>q",
          },
        },
      })

      vim.keymap.set("n", "<leader>bc", function()
        api.pick()
      end, { noremap = true, silent = true, desc = "Pick dropbar" })
    end,
  },
}
