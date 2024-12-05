-- map BufferNext and BufferPrevious to gt and gT
vim.keymap.set("n", "gt", function()
	vim.cmd("BufferNext")
end)
vim.keymap.set("n", "gT", function()
	vim.cmd("BufferPrevious")
end)

-- map shift + tab to indent left
vim.keymap.set("i", "<S-Tab>", "<C-d>")

-- save on cmd + s
vim.keymap.set({ "n", "i", "v" }, "<D-s>", function()
	vim.cmd("w")
end)

vim.keymap.set({ "n", "i", "v" }, "<D-w>", function()
	local Snacks = require("snacks")
	Snacks.bufdelete()
end)

-- reopen last closed buffer on cmd + shift + t
vim.keymap.set({ "n", "i", "v" }, "<S-D-T>", function()
	vim.cmd("BufferRestore")
end)

-- create a new buffer on cmd + n
vim.keymap.set({ "n" }, "<D-n>", function()
	vim.cmd("enew")
end)

-- undo on cmd + z
vim.keymap.set({ "n", "i" }, "<D-z>", function()
	vim.cmd("u")
end)

-- redo on cmd + shift + z
vim.keymap.set({ "n", "i" }, "<S-D-Z>", function()
	vim.cmd("redo")
end)

-- escape from terminal mode with shift + escape
vim.keymap.set("t", "<S-Esc>", "<C-\\><C-n>")

-- -- copy to clipboard
-- vim.keymap.set({ "n", "v" }, "<D-c>", function()
--   vim.cmd("silent! !pbcopy")
-- end)

-- -- paste from clipboard
-- vim.keymap.set({ "n", "i", "v" }, "<D-v>", function()
--   vim.cmd("silent! !pbpaste")
-- end)

-- lsp rename
vim.keymap.set("n", "<leader>rn", function()
	vim.lsp.buf.rename()
end)
