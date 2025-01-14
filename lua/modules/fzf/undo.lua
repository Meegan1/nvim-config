local M = {}

local function get_undo_entries()
	local entries = {}
	local undotree = vim.fn.undotree()

	for _, entry in ipairs(undotree.entries) do
		local time = os.date("%Y-%m-%d %H:%M:%S", entry.time)
		local seq = entry.seq
		local changes = entry.changes and entry.changes[1] or 0

		table.insert(entries, {
			seq = seq,
			time = time,
			changes = changes,
			alt = entry.alt and entry.alt[1] or nil,
		})
	end

	return entries
end

function M.undo()
	local entries = get_undo_entries()
	if #entries == 0 then
		vim.notify("No undo history available", vim.log.levels.INFO)
		return
	end

	require("fzf-lua").fzf_exec(function(cb)
		for _, entry in ipairs(entries) do
			cb(string.format("[%d] %s (%d changes)", entry.seq, entry.time, entry.changes))
		end
	end, {
		prompt = "Undo History> ",
		actions = {
			["default"] = function(selected)
				local seq = selected[1]:match("%[(%d+)%]")
				if seq then
					vim.cmd(string.format("undo %s", seq))
				end
			end,
		},
		preview = false,
	})
end

return M
