local curl = require("plenary.curl")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {
  schemas_catalog = "datreeio/CRDs-catalog",
  schema_catalog_branch = "main",
  github_base_api_url = "https://api.github.com/repos",
  github_headers = {
    Accept = "application/vnd.github+json",
    ["X-GitHub-Api-Version"] = "2022-11-28",
  },
}
M.schema_url = "https://raw.githubusercontent.com/" .. M.schemas_catalog .. "/" .. M.schema_catalog_branch

M.list_github_tree = function()
  local url = M.github_base_api_url .. "/" .. M.schemas_catalog .. "/git/trees/" .. M.schema_catalog_branch
  local response = curl.get(url, { headers = M.github_headers, query = { recursive = 1 } })
  local body = vim.fn.json_decode(response.body)
  local trees = {}
  for _, tree in ipairs(body.tree) do
    if tree.type == "blob" and tree.path:match("%.json$") then
      table.insert(trees, tree.path)
    end
  end
  return trees
end

M.init = function()
  local results = M.list_github_tree()

  if #results == 0 then
    return
  end

  opts = opts or {}
  pickers
      .new(opts, {
        prompt_title = "Select schema",
        finder = finders.new_table({
          results = results,
          entry_maker = function(entry)
            return {
              value = entry,
              display = entry,
              ordinal = entry,
            }
          end,
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            if not selection then
              require("user.utils").pretty_print("Canceled.")
              return
            end
            local schema_url = M.schema_url .. "/" .. selection.value
            local schema_modeline = "# yaml-language-server: $schema=" .. schema_url

            -- Find the nearest `---` line above the cursor
            local cursor_pos = vim.api.nvim_win_get_cursor(0)
            local line_num = cursor_pos[1] - 1
            local found_modeline = false
            local found_delimiter = false

            for i = line_num, 0, -1 do
              local line = vim.api.nvim_buf_get_lines(0, i, i + 1, false)[1]
              if line:match("^# yaml%-language%-server: %$schema=") then
                vim.api.nvim_buf_set_lines(0, i, i + 1, false, { schema_modeline })
                found_modeline = true
                break
              elseif line == "---" then
                vim.api.nvim_buf_set_lines(0, i + 1, i + 1, false, { schema_modeline })
                found_delimiter = true
                break
              end
            end

            -- If no modeline or `---` line is found, insert at the top
            if not found_modeline and not found_delimiter then
              vim.api.nvim_buf_set_lines(0, 0, 0, false, { schema_modeline })
            end

            vim.notify("Added schema modeline: " .. schema_modeline)
          end)
          return true
        end,
      })
      :find()
end

M.setup = function()
  vim.api.nvim_create_user_command("YamlSchemaInit", function()
    M.init()
  end, {
    desc = "Initialize YAML schema",
  })
end

return M
