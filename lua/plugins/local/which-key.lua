return {
  {
    "folke/which-key.nvim",
    version = "3.2.0",
    event = "VeryLazy",
    opts = {
      preset = "modern",
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
            keys = "<c-w>",
            loop = true, -- this will keep the popup open until you hit <esc>
          })
        end,
        desc = "Window Keymaps (which-key)",
      },
    },
  },
}
