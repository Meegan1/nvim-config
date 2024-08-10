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
vim.keymap.set({ 'n', 'x', 'v' }, '<D-s>', function()
  vim.cmd('w')
end)

-- close buffer on cmd + when there is no unsaved change
local function close_buffer_or_window()
  local buffers = vim.fn.getbufinfo({ buflisted = 1 })
  if #buffers == 1 then
    vim.cmd('BufferClose')
    vim.cmd('quit')
  else
    vim.cmd('BufferClose')
  end

  -- if in visual or insert mode, return to normal mode
  if vim.api.nvim_get_mode().mode == 'v' or vim.api.nvim_get_mode().mode == 'i' then
    vim.cmd('stopinsert')
  end
end

vim.keymap.set({ 'n', 'i', 'v' }, '<D-w>', close_buffer_or_window)

-- reopen last closed buffer on cmd + shift + t
vim.keymap.set({ 'n', 'i', 'v' }, '<S-D-t>', function()
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

-- set numbers enabled
vim.opt.number = true
-- disable relative numbers
vim.opt.relativenumber = false
