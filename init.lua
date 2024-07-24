require 'lazy.lazy-bootstrap'

require 'config.always'

if vim.g.vscode then
  -- VSCode config

  require 'config.vscode'
else
  -- Local neovim config

  require 'config.local'
end

require('lazy').setup({
  { import = "plugins.local",  cond = (function() return not vim.g.vscode end) },
  { import = "plugins.always", cond = true },
  { import = "plugins.vscode", cond = (function() return vim.g.vscode end) },
})
