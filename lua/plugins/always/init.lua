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
    "bkad/CamelCaseMotion",
  },
  {
    "tpope/vim-abolish",
  },
  {
    'andrewradev/splitjoin.vim'
  },
  {
    'echasnovski/mini.move',
    opts = {
      mappings = {
        left = '<A-h>',
        down = '<A-j>',
        up = '<A-k>',
        right = '<A-l>',

        line_left = '<A-h>',
        line_down = '<A-j>',
        line_up = '<A-k>',
        line_right = '<A-l>',
      }
    }
  }
}
