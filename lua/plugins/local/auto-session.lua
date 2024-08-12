return {
  {
    'rmagatti/auto-session',
    lazy = false,
    dependencies = {
      'nvim-telescope/telescope.nvim', -- Only needed if you want to use session lens
      'console_log',
    },
    config = function()
      local console_log = require('console_log')

      local close_neo_tree = function()
        require('neo-tree.sources.manager').close_all()
        console_log.log('Closed all NeoTree windows', vim.log.levels.DEBUG, { title = 'AutoSession' })
      end

      local open_neo_tree = function()
        console_log.log('Opening NeoTree window', vim.log.levels.DEBUG, { title = 'AutoSession' })
        require('neo-tree.sources.manager').show('filesystem')
      end

      -- If no directory is provided, don't auto restore the session
      local auto_restore_enabled = (function()
        local argv = vim.fn.argv()
        if #argv == 0 then
          return false
        end

        local path = argv[1]
        if path == nil or path == '' then
          return false
        end

        return true
      end)()

      require('auto-session').setup({
        auto_restore_enabled = auto_restore_enabled,
        auto_save_enabled = true,
        auto_session_suppress_dirs = { '~/', '~/Documents/Projects', '~/Downloads', '/' },
        bypass_session_save_file_types = { 'alpha' },

        -- only save session if we are inside a git repo
        auto_session_create_enabled = function()
          local cmd = 'git rev-parse --is-inside-work-tree'
          return vim.fn.system(cmd) == 'true\n'
        end,

        pre_save_cmds = {
          close_neo_tree,
        },
        post_restore_cmds = {
          open_neo_tree,
        },

        session_lens = {
          load_on_setup = true,
          theme_conf = {
            border = true,
            previewer = false,
            mappings = {
              -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
              delete_session = { "i", "<C-D>" },
              alternate_session = { "i", "<C-S>" },
            }
          }
        }
      })
    end,
  }
}
