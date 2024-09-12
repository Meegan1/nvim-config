return {
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    opts = {
      enable_autocmd = false,
    },
  },
  {
    "numToStr/Comment.nvim",
    opts = function()
      local pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
      return {
        pre_hook = pre_hook,
      }
    end,
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
  },
}
