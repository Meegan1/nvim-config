return {
  {
    'AndreM222/copilot-lualine',
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'AndreM222/copilot-lualine',
      'nvim-tree/nvim-web-devicons',
    },
    config = true,
    opts = {
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff',
          {
            'diagnostics',
            sources = { "nvim_diagnostic" },
            symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' }
          }
        },
        lualine_c = { 'filename' },
        lualine_x = { 'copilot', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location', 'searchcount' },
      },
    }
  },
}
