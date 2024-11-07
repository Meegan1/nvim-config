return {
  {
    "NeogitOrg/neogit",
    opts = {
      disable_insert_on_commit = true,
      graph_style = "unicode",
    },
    config = function(_, config)
      local neogit = require("neogit")
      neogit.setup(config)

      vim.keymap.set({ "n" }, "<leader>gs", function()
        neogit.open()
      end, { noremap = true, silent = true })
    end,
  },
}
