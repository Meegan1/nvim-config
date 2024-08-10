vim.keymap.set('n', '<C-B>', function()
  -- open the tree but dont focus it
  require('nvim-tree.api').tree.toggle({ focus = false })
end)

-- auto open nvim-tree when open neovim
local function open_nvim_tree(data)
  -- buffer is a real file on the disk
  local real_file = vim.fn.filereadable(data.file) == 1

  -- buffer is a [No Name]
  local no_name = data.file == '' and vim.bo[data.buf].buftype == ''

  -- only files please
  if not real_file and not no_name then
    return
  end

  -- open the tree but dont focus it
  require('nvim-tree.api').tree.toggle({ focus = false })
  vim.api.nvim_exec_autocmds('BufWinEnter', { buffer = require('nvim-tree.view').get_bufnr() })
end
-- vim.api.nvim_create_autocmd({ 'VimEnter' }, { callback = open_nvim_tree })

local function edit_or_open()
  local api = require('nvim-tree.api')

  local node = api.tree.get_node_under_cursor()

  if node.nodes ~= nil then
    -- expand or collapse folder
    api.node.open.edit()
  else
    -- open file
    api.node.open.edit()
  end
end

-- keymap for nvim-tree
function on_nvim_tree_attach(bufnr)
  local opts = function(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- open files when pressing l
  vim.keymap.set('n', 'l', edit_or_open, opts('Edit or Open'))
end

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
vim.keymap.set({ 'n' }, '<D-w>', ':BufferClose<CR>')
vim.keymap.set({ 'i' }, '<D-w>', '<C-o>:BufferClose<CR>')
vim.keymap.set({ 'v' }, '<D-w>', ':BufferClose<CR>')

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
