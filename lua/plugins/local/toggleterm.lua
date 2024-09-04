return {
  -- Toggle term
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    lazy = false,
    opts = {
      size = 20,
      open_mapping = [[<D-j>]],
      dir = "git_dir",
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      close_on_exit = true,
      shell = vim.o.shell,
    },
    keys = {
      {
        "<D-j>",
        "<cmd>:ToggleTerm<cr>",
        desc = "Toggle Term",
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

      function _lazygit_toggle()
        lazygit:toggle()
      end

      vim.keymap.set({ "n", "i", "v", "t" }, "<D-g>", _lazygit_toggle, { noremap = true, silent = true })
    end,
  },
}
