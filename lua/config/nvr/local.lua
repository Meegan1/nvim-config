if vim.fn.has('nvim') == 1 and vim.fn.executable('nvr') == 1 then
  vim.env.GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"

  vim.env.LG_CONFIG_FILE = vim.fn.stdpath("config") .. "/.config/lazygit/config.yaml"
end
