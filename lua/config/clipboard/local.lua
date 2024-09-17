-- vim.o.clipboard = "unnamedplus"

local function my_paste(reg)
  -- get os
  local os = vim.uv.os_uname().sysname
  if os == "Linux" then
    -- check if xclip is installed
    if vim.fn.executable("xclip") == 1 then
      content = "xclip -o -selection clipboard"
    else
      -- info: disable inside wezterm, as wezterm doesn't support reading from OSC 52
      return function(lines)
        local content = vim.fn.getreg('"')
        return vim.split(content, "\n")
      end
    end
  elseif os == "Darwin" then
    content = "pbpaste"
  elseif os == "Windows" then
    content = "Get-Clipboard"
  else
    print("Unsupported OS")
    return
  end

  return content
end

-- Use OSC 52 clipboard for neovim
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = my_paste("+"),
    ["*"] = my_paste("*"),
  },
}
