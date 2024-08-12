local console_log_defaults = {
  level = vim.log.levels.INFO,
}

local ConsoleLog = {}

function ConsoleLog.setup(opts)
  ConsoleLog.opts = vim.tbl_extend('force', console_log_defaults, opts or {})
end

function ConsoleLog.get_opts()
  return vim.tbl_deep_extend('force', console_log_defaults, ConsoleLog.opts or {})
end

function ConsoleLog.log(msg, level, options)
  local opts = ConsoleLog.get_opts()

  if opts.level <= level then
    vim.notify(msg, level, options)
  end
end

-- local instance = ConsoleLog:new()

return ConsoleLog
