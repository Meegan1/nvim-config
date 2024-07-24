function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
  map('n', shortcut, command)
end

function imap(shortcut, command)
  map('i', shortcut, command)
end

vim.g.mapleader = " "

-- <Leader>f{char} to move to {char}
vim.api.nvim_set_keymap('n', '<Leader>f', '<Plug>(easymotion-bd-f)', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>f', '<Plug>(easymotion-overwin-f)', { noremap = true, silent = true })

vim.keymap.set({ 'n', 'v' }, 'gb', '<C-n>', { remap = true })
