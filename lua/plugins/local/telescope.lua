return {
  {
    "nvim-telescope/telescope.nvim",
    config = function(_, opts)
      require("telescope").setup(opts)

      vim.keymap.set({ "n", "i", "v" }, "<D-p>", function()
        require("telescope.builtin").find_files()
      end)

      vim.keymap.set({ "n", "i", "v" }, "<D-P>", function()
        require("telescope.builtin").commands()
      end)

      vim.keymap.set("n", "<D-F>", function()
        require("telescope.builtin").live_grep()
      end)

      vim.keymap.set("n", "<D-t>", function()
        require("telescope.builtin").lsp_workspace_symbols()
      end)
    end,
  },
  {
    "debugloop/telescope-undo.nvim",
    dependencies = { -- note how they're inverted to above example
      {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    opts = {
      -- don't use `defaults = { }` here, do this in the main telescope spec
      extensions = {
        undo = {
          -- telescope-undo.nvim config, see below
        },
        -- no other extensions here, they can have their own spec too
      },
    },
    config = function(_, opts)
      -- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
      -- configs for us. We won't use data, as everything is in it's own namespace (telescope
      -- defaults, as well as each extension).
      require("telescope").setup(opts)
      require("telescope").load_extension("undo")

      vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>", {
        desc = "undo history",
      })
    end,
  },
}
