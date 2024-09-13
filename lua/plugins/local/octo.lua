return {
  {
    "pwntester/octo.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      -- OR 'ibhagwan/fzf-lua',
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("octo").setup()
      local Job = require("plenary.job")

      -- add a command for checking out an issue from issue id in popup
      vim.api.nvim_create_user_command("CheckoutIssue", function()
        -- get the issue id from popup
        local issue_id = vim.fn.input("Issue ID: ")

        -- check if issue id is not empty
        if issue_id ~= "" then
          -- run gh issue develop <issue_id> --checkout
          Job:new({
            command = "gh",
            args = { "issue", "develop", issue_id, "--checkout", "--base", "main" },
            on_exit = function(j, return_val)
              if return_val == 0 then
                vim.notify("Checked out issue", "info", { title = "Octo" })
              else
                vim.notify(vim.inspect(j:stderr_result()), "error", { title = "Octo" })
                vim.notify("Failed to checkout issue", "error", { title = "Octo" })
              end
            end,
          }):start()
        end
      end, {
        desc = "Checkout an issue",
      })
    end,
    cond = function()
      -- check if gh is installed
      return vim.fn.executable("gh") == 1
    end,
  },
}
