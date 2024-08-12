-- bind <C-b> to toggle neotree
vim.keymap.set({ 'n', 'i', 'v' }, '<D-b>', function()
  vim.cmd('Neotree toggle')
end
)

-- bind <C-A-M-f> to find file in neotree
vim.keymap.set({ 'n', 'i', 'v' }, '<C-f>', function()
  vim.cmd('Neotree reveal')
end
)
