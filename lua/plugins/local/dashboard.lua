return {
  "goolord/alpha-nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local dashboard = require("alpha.themes.dashboard")

    local current_dir = vim.fn.expand("%:p:h")

    -- create highlight groups
    vim.api.nvim_set_hl(0, "DashboardHeaderTitle", { fg = "#89b4fa" })
    vim.api.nvim_set_hl(0, "DashboardHeaderPenguin", { fg = "#cdd6f4" })

    local title = {
      [[                                                     ]],
      [[  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ]],
      [[  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ]],
      [[  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ]],
      [[  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
      [[  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
      [[  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
    }
    local penguin = {
      [[                                            __       ]],
      [[                                         -=(o '.     ]],
      [[                                            '.-.\    ]],
      [[                                            /|  \\   ]],
      [[                                            '|  ||   ]],
      [[                                             _\_):,_ ]],
      [[                                                     ]],
    }

    dashboard.section.header.type = "group"
    dashboard.section.header.val = {
      {
        type = "text",
        val = title,
        opts = { hl = "DashboardHeaderTitle", position = "center" },
      },
      {
        type = "text",
        val = penguin,
        opts = { hl = "DashboardHeaderPenguin", position = "center" },
      },
    }

    dashboard.section.buttons.val = {
      dashboard.button("r", "  Open " .. current_dir, ":SessionRestore " .. current_dir .. "<CR>"),
      {
        type = "padding",
        val = 1,
      },
      dashboard.button("e", "  New file", ":enew<CR>"),
      dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
      dashboard.button("p", "  Recently opened projects", ":Telescope session-lens<CR>"),
      dashboard.button("h", "  Recently opened files", ":Telescope oldfiles<CR>"),
      dashboard.button("q", "  Quit", ":qa<CR>"),
    }

    require("alpha").setup(dashboard.opts)
  end,
}
