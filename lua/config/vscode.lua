local vscode = require('vscode')

-- Go to next problem in file
vim.keymap.set('n', '<Leader>p', function()
  vscode.call("editor.action.marker.next")
  -- vscode.call("closeMarkersNavigation")
end, { remap = true })

-- Get folding working with vscode neovim plugin
vim.keymap.set('n', 'zM', function()
  vscode.call('editor.foldAll')
end, { remap = true, silent = true })
vim.keymap.set('n', 'zR', function()
  vscode.call('editor.unfoldAll')
end, { remap = true, silent = true })
vim.keymap.set('n', 'zc', function()
  vscode.call('editor.fold')
end, { remap = true, silent = true })
vim.keymap.set('n', 'zC', function()
  vscode.call('editor.foldRecursively')
end, { remap = true, silent = true })
vim.keymap.set('n', 'zo', function()
  vscode.call('editor.unfold')
end, { remap = true, silent = true })
vim.keymap.set('n', 'zO', function()
  vscode.call('editor.unfoldRecursively')
end, { remap = true, silent = true })
vim.keymap.set('n', 'za', function()
  vscode.call('editor.toggleFold')
end, { remap = true, silent = true })

-- Move cursor up and down above folds
vim.keymap.set('n', 'j', 'gj', { remap = true })
vim.keymap.set('n', 'k', "gk", { remap = true })

-- Move between splits with ctrl + hjkl
-- vim.keymap.set({ 'n', 'x' }, '<C-j>', function()
--   vscode.call("workbench.action.navigateDown")
-- end, { noremap = true })
-- vim.keymap.set({ 'n', 'x' }, '<C-k>', function()
--   vscode.call("workbench.action.navigateUp")
-- end, { noremap = true })
-- vim.keymap.set({ 'n', 'x' }, '<C-h>', function()
--   vscode.call("workbench.action.navigateLeft")
-- end, { noremap = true })
-- vim.keymap.set({ '', 'x' }, '<C-l>', function()
--   vscode.call("workbench.action.navigateRight")
-- end, { noremap = true })


-- Rename symbol
vim.keymap.set('n', '<Leader>rn', function()
  vscode.call("editor.action.rename")
end, { noremap = true })
