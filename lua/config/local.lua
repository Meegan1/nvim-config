-- map BufferNext and BufferPrevious to gt and gT
vim.keymap.set('n', 'gt', ':BufferNext<CR>')
vim.keymap.set('n', 'gT', ':BufferPrevious<CR>')

-- map shift + tab to indent left
vim.keymap.set('i', '<S-Tab>', '<C-d>')

-- save on cmd + s
vim.keymap.set({ 'n' }, '<D-s>', ':w<CR>')
vim.keymap.set({ 'i' }, '<D-s>', '<C-o>:w<CR>')
vim.keymap.set({ 'v' }, '<D-s>', ':w<CR>')

-- close buffer on cmd + when there is no unsaved change
local function close_buffer_or_window()
  local buffers = vim.fn.getbufinfo({ buflisted = 1 })
  if #buffers == 1 then
    vim.cmd('BufferClose')
    vim.cmd('quit')
  else
    vim.cmd('BufferClose')
  end
end

vim.keymap.set({ 'n' }, '<D-w>', close_buffer_or_window)
vim.keymap.set({ 'i' }, '<D-w>', '<C-o>:lua close_buffer_or_window()<CR>')
vim.keymap.set({ 'v' }, '<D-w>', ':lua close_buffer_or_window()<CR>')

-- reopen last closed buffer on cmd + shift + t
vim.keymap.set({ 'n' }, '<S-D-t>', ':BufferRestore<CR>')
vim.keymap.set({ 'i' }, '<S-D-t>', '<C-o>:BufferRestore<CR>')
vim.keymap.set({ 'v' }, '<S-D-t>', ':BufferRestore<CR>')

-- create a new buffer on cmd + n
vim.keymap.set({ 'n' }, '<D-n>', ':enew<CR>')

-- undo on cmd + z
vim.keymap.set({ 'n' }, '<D-z>', ':u<CR>')
vim.keymap.set({ 'i' }, '<D-z>', '<C-o>:u<CR>')

-- redo on cmd + shift + z
vim.keymap.set({ 'n' }, '<S-D-Z>', ':red<CR>')
vim.keymap.set({ 'i' }, '<S-D-Z>', '<C-o>:red<CR>')

-- set numbers enabled
vim.opt.number = true
-- disable relative numbers
vim.opt.relativenumber = false
