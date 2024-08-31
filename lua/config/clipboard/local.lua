local function my_paste(reg)
	local content

	-- get os
	local os = vim.uv.os_uname().sysname
	if os == "Linux" then
		content = "xclip -o -selection clipboard"
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
