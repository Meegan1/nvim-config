return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim",           -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    opts = {
      -- auto_clean_after_session_restore = true,
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          never_show = {
            ".DS_Store",
            ".git",
          },
        },
      },
      window = {
        mappings = {
          ["l"] = "open",
          ["o"] = "toggle_node",
          ["oc"] = "noop",
          ["od"] = "noop",
          ["og"] = "noop",
          ["om"] = "noop",
          ["on"] = "noop",
          ["os"] = "noop",
          ["ot"] = "noop",
          ["s"] = "noop",
          ["S"] = "open_vsplit",
        },
      },
      -- file nesting
      nesting_rules = {
        ["js"] = {
          "test.js",
          "spec.js",
          "stories.js",
        },
        ["ts"] = {
          "test.ts",
          "spec.ts",
          "stories.ts",
        },
        ["jsx"] = {
          "test.jsx",
          "spec.jsx",
          "stories.jsx",
        },
        ["tsx"] = {
          "test.tsx",
          "spec.tsx",
          "stories.tsx",
        },
        ["package.json"] = {
          pattern = "^package%.json$",         -- <-- Lua pattern
          files = { "package-lock.json", "yarn*" }, -- <-- glob pattern
        },
      },
      -- lsp
      lsp = {
        hover = {
          silent = true,
        },
      },
    },
  },
}
