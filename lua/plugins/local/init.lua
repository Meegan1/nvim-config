return {
  { "tpope/vim-commentary", },
  { 'markonm/traces.vim' },
  {
    'nvim-telescope/telescope.nvim',
    config = function(_, opts)
      require('telescope').setup(opts)

      vim.keymap.set({ 'n', 'i', 'v' }, '<D-p>', function()
        require('telescope.builtin').find_files()
      end)
    end
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
  },
}
