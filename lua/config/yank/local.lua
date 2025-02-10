-- Preserves cursor position after yanking
local preserve_cursor = {}

preserve_cursor.state = {
	cursor = { 0, 0 },
}
vim.api.nvim_create_autocmd({ "VimEnter", "CursorMoved" }, {
	group = vim.api.nvim_create_augroup("NoMoveYank", { clear = true }),
	callback = function()
		preserve_cursor.state.cursor = vim.api.nvim_win_get_cursor(0)
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = "NoMoveYank",
	callback = function()
		if vim.v.event.operator == "y" and preserve_cursor.state.cursor then
			vim.api.nvim_win_set_cursor(0, preserve_cursor.state.cursor)
		end
	end,
})

-- Highlight yanked text
vim.api.nvim_set_hl(0, "YankHighlight", { link = "Search", default = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	callback = function()
		pcall(vim.highlight.on_yank, { higroup = "YankHighlight", timeout = 200 })
	end,
})
