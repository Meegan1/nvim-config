return {
  dir = vim.fn.stdpath("config") .. "/plugins/console_log",
  name = "console_log",
  opts = {
    level = vim.log.levels.INFO,
  }
}
