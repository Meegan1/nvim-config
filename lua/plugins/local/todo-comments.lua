return {
  {
    "folke/todo-comments.nvim",
    opts = function()
      local default_keywords = {
        FIX = {
          icon = " ", -- icon used for the sign, and in search results
          color = "error", -- can be a hex color, or a named color (see below)
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
          -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      }

      local keywords = {}

      keywords = vim.tbl_deep_extend("force", {}, default_keywords, keywords)
      -- Add lowercase versions of each keyword as alt keywords, including current alt keywords
      for _, keyword in pairs(vim.tbl_keys(keywords)) do
        -- copy the current alt keywords
        local alt = {}
        if keywords[keyword].alt then
          for _, alt_keyword in pairs(keywords[keyword].alt) do
            table.insert(alt, alt_keyword)
          end
        end

        if not keywords[keyword].alt then
          keywords[keyword].alt = {}
        end

        for _, alt_keyword in pairs(alt) do
          -- check if the alt keyword is already in the list of alt keywords
          if not vim.tbl_contains(alt, alt_keyword:lower()) then
            table.insert(keywords[keyword].alt, alt_keyword:lower())
          end
        end

        -- check if the keyword is already in the list of alt keywords
        if not vim.tbl_contains(keywords[keyword].alt, keyword:lower()) then
          table.insert(keywords[keyword].alt, keyword:lower())
        end
      end

      return {
        keywords = keywords,
      }
    end,
    config = function(_, opts)
      require("todo-comments").setup(opts)
    end,
  },
}
