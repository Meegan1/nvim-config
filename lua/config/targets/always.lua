-- Enable arguments inside json objects
vim.api.nvim_exec2([[
  autocmd User targets#mappings#user call targets#mappings#extend({
    \ 'a': {
    \   'argument': [
    \     {'o': '[{([]', 'c': '[])}]', 's': ','}
    \   ]
    \ }
  \ })
]], {})
