return {
  {
    "echasnovski/mini.indentscope",
    opts = function()
      vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#3b4261" })

      return {
        draw = {
          delay = 0,
          animation = require("mini.indentscope").gen_animation.none(),
        },
        options = {
          try_as_border = true,
        },
        symbol = "▎",
      }
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {
      scope = {
        enabled = false,
      },
    },
  },
}
