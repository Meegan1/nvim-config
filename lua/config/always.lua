-- Set leader key to space
vim.g.mapleader = " "

-- <Leader>f{char} to move to {char}
vim.api.nvim_set_keymap('n', '<Leader>f', '<Plug>(easymotion-bd-f)', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>f', '<Plug>(easymotion-overwin-f)', { noremap = true, silent = true })

-- gb to select next occurence of word under cursor as multiple cursors
vim.keymap.set({ 'n', 'v' }, 'gb', '<C-n>', { remap = true })
