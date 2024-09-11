return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = true,
    opts = {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = false,
          accept_word = "<D-l>",
          accept_line = "<C-l>",
          next = false,
          prev = false,
          dismiss = false,
        },
      },
      filetypes = {
        yaml = true,
        markdown = true,
      },
    },
  },
}
