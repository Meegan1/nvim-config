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

-- keymap for nvim-tree
function on_nvim_tree_attach()
  local api = require('nvim-tree.api')

  -- open files when pressing l
  vim.keymap.set('n', 'l', api.node.open.edit)
end
