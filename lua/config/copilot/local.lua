vim.keymap.set('i', '<Tab>', function()
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").accept()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
  end
end, {
  silent = true,
})

vim.keymap.set('i', '<S-Esc>', function()
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").dismiss()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Esc>", true, false, true), "n", false)
  end
end, {
  silent = true,
})
