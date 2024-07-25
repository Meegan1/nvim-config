vim.g.VM_leader = '<Leader><Leader>'

-- gb to select next occurence of word under cursor as multiple cursors
vim.keymap.set({ 'n', 'v' }, 'gb', '<C-n>', { remap = true })

-- Set the color of the cursor for multi-cursor when in cursor mode
vim.api.nvim_set_hl(0, 'VM_Mono', { bg = 'Grey60', fg = 'black' })


-- Override the default keymaps for visual-multi
function VM_Start()
  -- map CTRL+move to arrow keys
  vim.api.nvim_buf_set_keymap(0, 'n', '<C-l>', '<Right>', { noremap = true })
  vim.api.nvim_buf_set_keymap(0, 'n', '<C-h>', '<Left>', { noremap = true })
  vim.api.nvim_buf_set_keymap(0, 'n', '<C-j>', '<Down>', { noremap = true })
  vim.api.nvim_buf_set_keymap(0, 'n', '<C-k>', '<Up>', { noremap = true })
end

-- Remove the keymaps when visual-multi is exited
function VM_Exit()
  vim.api.nvim_buf_del_keymap(0, 'n', '<C-l>')
  vim.api.nvim_buf_del_keymap(0, 'n', '<C-h>')
  vim.api.nvim_buf_del_keymap(0, 'n', '<C-j>')
  vim.api.nvim_buf_del_keymap(0, 'n', '<C-k>')
end

-- Create autocommands
vim.api.nvim_create_autocmd("User", {
  pattern = "visual_multi_start",
  callback = VM_Start
})

vim.api.nvim_create_autocmd("User", {
  pattern = "visual_multi_exit",
  callback = VM_Exit
})
