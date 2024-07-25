-- <Leader>f{char} to move to {char}
vim.api.nvim_set_keymap('n', '<Leader>f', '<Plug>(easymotion-bd-f)', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>f', '<Plug>(easymotion-overwin-f)', { noremap = true, silent = true })
