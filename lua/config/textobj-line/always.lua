vim.g.textobj_line_no_default_key_mappings = 1

vim.keymap.set({ 'v', 'o' }, 'aL', '<Plug>(textobj-line-a)')
vim.keymap.set({ 'v', 'o' }, 'iL', '<Plug>(textobj-line-i)')
