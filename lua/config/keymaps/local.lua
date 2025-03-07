-- map BufferNext and BufferPrevious to gt and gT
vim.keymap.set("n", "gt", function()
	vim.cmd("BufferNext")
end)
vim.keymap.set("n", "gT", function()
	vim.cmd("BufferPrevious")
end)

vim.keymap.set({
	"i",
}, "<Char-1106366>", "<C-d>")

-- map shift + tab to indent left
vim.keymap.set("i", "<S-Tab>", "<C-d>")

-- save on cmd + s
vim.keymap.set({ "n", "i", "v" }, "<C-s>", function()
	vim.cmd("w")
end)

vim.keymap.set({ "n", "i", "v" }, "<D-w>", function()
	local Snacks = require("snacks")
	Snacks.bufdelete()
end)

-- reopen last closed buffer on cmd + shift + t
vim.keymap.set({ "n", "i", "v" }, "<C-S-T>", function()
	vim.cmd("BufferRestore")
end)

-- create a new buffer on cmd + n
vim.keymap.set({ "n" }, "<C-S-n>", function()
	vim.cmd("enew")
end)

-- undo on cmd + z
vim.keymap.set({ "n", "i" }, "<C-z>", function()
	vim.cmd("u")
end)

-- redo on cmd + shift + z
vim.keymap.set({ "n", "i" }, "<C-S-Z>", function()
	vim.cmd("redo")
end)

-- escape from terminal mode with shift + escape
vim.keymap.set("t", "<S-Esc>", "<C-\\><C-n>")

-- lsp rename
vim.keymap.set("n", "<leader>rn", function()
	vim.lsp.buf.rename()
end)

-- Move visual/wrapped lines with j/k whilst preserving v.count expressions
vim.keymap.set({ "n", "x" }, "j", function()
	return vim.v.count > 0 and "j" or "gj"
end, { expr = true })
vim.keymap.set({ "n", "x" }, "k", function()
	return vim.v.count > 0 and "k" or "gk"
end, { expr = true })
