require 'lazy.lazy-bootstrap'
local require_files = require 'utils.require-files'

require_files('config', 'always')

if vim.g.vscode then
  -- VSCode config

  require_files('config', 'vscode')
else
  -- Local neovim config

  require_files('config', 'local')
end

require('lazy').setup({
  { import = "plugins.local",  cond = (function() return not vim.g.vscode end) },
  { import = "plugins.always", cond = true },
  { import = "plugins.vscode", cond = (function() return vim.g.vscode end) },
})
