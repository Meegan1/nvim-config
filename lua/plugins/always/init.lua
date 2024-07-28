return {
  { 'tpope/vim-repeat', },
  { 'tpope/vim-surround', },
  { 'easymotion/vim-easymotion' },
  { 'wellle/targets.vim' },
  {
    'kana/vim-textobj-entire',
    dependencies = {
      'kana/vim-textobj-user'
    }
  },
  {
    'kana/vim-textobj-line',
    dependencies = {
      'kana/vim-textobj-user'
    }
  },
  {
    "mg979/vim-visual-multi",
  },
  {
    "bkad/CamelCaseMotion"
  },
  -- {
  --   'smjonas/live-command.nvim',
  --   opts = {
  --     commands = {
  --       S = { cmd = "Subvert" }, -- must be defined before we import vim-abolish
  --     },
  --   }
  -- },
  {
    'markonm/traces.vim'
  },
  {
    "tpope/vim-abolish",
    -- dependencies = {
    --   'smjonas/live-command.nvim'
    -- }
  }
}
