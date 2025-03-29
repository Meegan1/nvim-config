local M = {}

M.snips = {}

-- Check if LuaSnip is available
local function check_luasnip()
	local has_luasnip, _ = pcall(require, "luasnip")
	return has_luasnip
end

-- Query LuaSnip snippets
local function query_luasnip()
	local function query(ft)
		local has_luasnip, luasnip = pcall(require, "luasnip")
		if not has_luasnip then
			return {}
		end
		local snippets = luasnip.get_snippets(ft)
		local result = {}
		for _, snippet in ipairs(snippets) do
			local item = { snippet.trigger, snippet:get_docstring() }
			table.insert(result, item)
		end
		return result
	end

	local hr = query(vim.o.filetype)
	local list = {}
	local size = 4

	for _, item in ipairs(hr) do
		local trigger = item[1]
		local body = item[2]
		size = math.max(size, #trigger)
		table.insert(list, { trigger, body })
	end

	for _, item in ipairs(list) do
		local t = item[1] .. string.rep(" ", size - #item[1])
		table.insert(item, t)
	end

	table.sort(list, function(a, b)
		return a[1] < b[1]
	end)
	return list
end

-- Simplify snippet description
local function simplify_description(body, width)
	if not body then
		return ""
	end
	-- Split the code snippet by line and join with " ; "
	local text = table.concat(vim.split(body, "\n"), " ; ")
	-- Remove leading and trailing whitespace
	text = vim.fn.substitute(text, [[^\s*\(.\{-}\)\s*$]], [[\1]], "")
	-- Replace `${...}` placeholders with "..."
	text = vim.fn.substitute(text, [[\${[^{}]*}]], "...", "g")
	-- Replace consecutive spaces with a single space
	text = vim.fn.substitute(text, [[\s\+]], " ", "g")
	return text:sub(1, width or 100)
end

-- Get snippets from LuaSnip
local function get_snippets()
	if not check_luasnip() then
		vim.notify("LuaSnip is not available", vim.log.levels.ERROR)
		return {}
	end

	local result = query_luasnip()
	local source = {}
	local snips = {}
	local width = 100

	for _, item in ipairs(result) do
		local trigger = item[1]
		local body = item[2]
		local desc = simplify_description(body, width)
		snips[trigger] = body
		local text = item[3] .. " : " .. desc
		table.insert(source, text)
	end

	M.snips = snips
	return source
end

-- Apply the selected snippet
local function apply_snippet(trigger)
	if trigger == "" then
		return
	end

	local in_insert_mode = vim.fn.mode(1):find("i")
	local keys

	if in_insert_mode then
		keys = vim.api.nvim_replace_termcodes(trigger .. "<Plug>luasnip-expand-or-jump", true, false, true)
	else
		keys = vim.api.nvim_replace_termcodes("a" .. trigger .. "<Plug>luasnip-expand-or-jump", true, false, true)
	end

	vim.api.nvim_feedkeys(keys, "!", false)
end

-- Process the selected snippet from fzf
local function handle_selection(selected)
	local text = selected[1]
	local pos = text:find(":")
	if not pos then
		return
	end

	local trigger = text:sub(1, pos - 1):gsub("^%s*(.-)%s*$", "%1")
	apply_snippet(trigger)
end

-- Create snippet previewer
local function create_previewer()
	local fzf_lua = require("fzf-lua")
	local builtin = require("fzf-lua.previewer.builtin")
	local Previewer = builtin.base:extend()

	function Previewer:new(o, opts, fzf_win)
		Previewer.super.new(self, o, opts, fzf_win)
		setmetatable(self, Previewer)
		return self
	end

	function Previewer:populate_preview_buf(entry_str)
		local pos = entry_str:find(":")
		if not pos then
			return {}
		end

		local trigger = entry_str:sub(1, pos - 1):gsub("^%s*(.-)%s*$", "%1")
		local body = M.snips[trigger] or ""

		if body == "" then
			return {}
		end

		local tmpbuf = self:get_tmp_buffer()
		local lines = vim.split(body, "\n")
		vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, lines)
		self:set_preview_buf(tmpbuf)
		-- Safely update scrollbar if the method exists
		if self.win and type(self.win.update_scrollbar) == "function" then
			self.win:update_scrollbar()
		end
	end

	function Previewer:gen_winopts()
		return vim.tbl_extend("force", self.winopts, { wrap = false, number = false })
	end

	return Previewer
end

-- Main function to find and display snippets
function M.find_snippets()
	local snippets = get_snippets()

	if #snippets == 0 then
		vim.notify("No snippets available for current filetype", vim.log.levels.INFO)
		return
	end

	require("fzf-lua").fzf_exec(snippets, {
		prompt = "LuaSnippets> ",
		previewer = {
			_ctor = create_previewer,
		},
		actions = {
			["default"] = handle_selection,
		},
	})
end

return M
