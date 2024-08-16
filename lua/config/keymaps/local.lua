-- map BufferNext and BufferPrevious to gt and gT
vim.keymap.set('n', 'gt', function()
  vim.cmd('BufferNext')
end)
vim.keymap.set('n', 'gT', function()
  vim.cmd('BufferPrevious')
end)

-- map shift + tab to indent left
vim.keymap.set('i', '<S-Tab>', '<C-d>')

-- save on cmd + s
vim.keymap.set({ 'n', 'i', 'v' }, '<D-s>', function()
  vim.cmd('w')
end)

vim.keymap.set({ 'n', 'i', 'v' }, '<D-w>', function()
  vim.cmd('CloseTab')
end)

-- reopen last closed buffer on cmd + shift + t
vim.keymap.set({ 'n', 'i', 'v' }, '<S-D-T>', function()
  vim.cmd('BufferRestore')
end)

-- create a new buffer on cmd + n
vim.keymap.set({ 'n' }, '<D-n>', function()
  vim.cmd('enew')
end)

-- undo on cmd + z
vim.keymap.set({ 'n', 'i' }, '<D-z>', function()
  vim.cmd('u')
end)

-- redo on cmd + shift + z
vim.keymap.set({ 'n', 'i' }, '<S-D-Z>', function()
  vim.cmd('redo')
end)

-- escape from terminal mode with shift + escape
vim.keymap.set('t', '<S-Esc>', '<C-\\><C-n>')
