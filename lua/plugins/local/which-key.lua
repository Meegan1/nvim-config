return {
  {
    "folke/which-key.nvim",
    version = "3.10.0",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      plugins = {
        presets = {
          text_objects = false,
        },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
      {
        "<leader><C-w>",
        function()
          require("which-key").show({
            keys = "<C-w>",
            loop = true, -- this will keep the popup open until you hit <esc>
          })
        end,
        desc = "Window Keymaps (which-key)",
      },
    },
    config = function(_, opts)
      local wk = require("which-key")

      wk.setup(opts)

      wk.add({
        nowait = false,
        {
          "<A-w>",
          desc = "Resize windows",
          function()
            wk.show({
              keys = "<A-w>",
              loop = true,
            })
          end,
        },
      })

      wk.add({
        nowait = false,
        {
          "<A-S-w>",
          desc = "Swap windows",
          function()
            wk.show({
              keys = "<A-S-w>",
              loop = true,
            })
          end,
        },
      })

      wk.add({
        nowait = false,
        {
          "<A-b>",
          desc = "Organize buffers",
          function()
            wk.show({
              keys = "<A-b>",
              loop = true,
            })
          end,
        },
      })
    end,
  },
}
