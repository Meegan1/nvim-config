return {
  -- Toggle term
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    lazy = false,
    opts = {
      size = 20,
      dir = "git_dir",
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = -50,
      start_in_insert = false,
      persist_size = true,
      close_on_exit = true,
      shell = vim.o.shell,
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      local toggleterm = require("toggleterm")

      local Terminal = require("toggleterm.terminal").Terminal

      -- Default terminal
      function _default_toggle()
        toggleterm.toggle()
      end

      vim.keymap.set({ "n", "i", "v", "t" }, "<D-j>", _default_toggle, { noremap = true, silent = true })

      -- Lazygit
      local lazygit =
          Terminal:new({ cmd = "lazygit", hidden = true, direction = "float", start_in_insert = true })

      function _lazygit_toggle()
        lazygit:toggle()
      end

      vim.keymap.set({ "n", "i", "v", "t" }, "<D-g>", _lazygit_toggle, { noremap = true, silent = true })
    end,
  },
}
