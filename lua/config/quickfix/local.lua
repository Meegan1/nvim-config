vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "q", function()
      vim.cmd("q")
    end, { buffer = true, silent = true })
  end,
})
