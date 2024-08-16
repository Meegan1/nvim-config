return {
  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
    config = function(_, opts)
      require("trouble").setup(opts)

      vim.diagnostic.config({
        virtual_text = {
          severity = {
            min = vim.diagnostic.severity.ERROR
          }
        }
      })

      -- vim.api.nvim_create_autocmd({ "CursorHold" }, {
      --   pattern = "*",
      --   callback = function()
      --     for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
      --       if vim.api.nvim_win_get_config(winid).zindex then
      --         return
      --       end
      --     end
      --     vim.diagnostic.open_float({
      --       scope = "cursor",
      --       focusable = false,
      --       close_events = {
      --         "CursorMoved",
      --         "CursorMovedI",
      --         "BufHidden",
      --         "InsertCharPre",
      --         "WinLeave",
      --       },
      --     })
      --   end
      -- })
    end,
  },
}
