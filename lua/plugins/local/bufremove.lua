return {
  {
    "echasnovski/mini.bufremove",

    config = function()
      require("mini.bufremove").setup()


      -- Create a command called CloseTab that closes the current tab.
      vim.api.nvim_create_user_command('CloseTab', function()
          local bd = require("mini.bufremove").delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then -- No
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        {
        }
      )

      vim.keymap.set({ 'n', 'v' }, "<leader>bd", function()
        vim.cmd("CloseTab")
      end, { noremap = true, desc = "Delete Buffer" })

      vim.keymap.set({ 'n', 'v' }, "<leader>bD", function()
        require("mini.bufremove").delete(0, true)
      end, { noremap = true, desc = "Delete Buffer (Force)" })
    end,
  },
}
