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
