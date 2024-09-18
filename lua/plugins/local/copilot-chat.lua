return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      show_help = "yes",      -- Show help text for CopilotChatInPlace, default: yes
      debug = false,          -- Enable or disable debug mode, the log file will be in ~/.local/state/nvim/CopilotChat.nvim.log
      disable_extra_info = "no", -- Disable extra information (e.g: system prompt) in the response.
      language = "English",   -- Copilot answer language settings when using default prompts. Default language is English.
      -- proxy = "socks5://127.0.0.1:3000", -- Proxies requests via https or socks.
      -- temperature = 0.1,
    },
    build = function()
      vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
    end,
    event = "VeryLazy",
    keys = {
      -- Clear buffer and chat history
      {
        "<leader>cl",
        function()
          vim.cmd("CopilotChatReset")
        end,
        desc = "CopilotChat - Clear buffer and chat history",
      },
      -- Toggle Copilot Chat
      {
        "<leader>cc",
        function()
          vim.cmd("CopilotChatToggle")
        end,
        desc = "CopilotChat - Toggle",
      },
      -- Copilot Chat Models
      {
        "<leader>c?",
        function()
          vim.cmd("CopilotChatModels")
        end,
        desc = "CopilotChat - Select Models",
      },
      {
        "<leader>cc",
        function()
          vim.cmd("CopilotChatVisual")
        end,
        mode = {
          "x",
          "n",
        },
        desc = "CopilotChat - Toggle",
      },
      -- Fix the issue with diagnostic
      {
        "<leader>cf",
        function()
          vim.cmd("CopilotChatFixDiagnostic")
        end,
        desc = "CopilotChat - Fix Diagnostic",
      },
      {
        "<leader>ci",
        function()
          vim.cmd("CopilotChatInline")
        end,
        mode = {
          "x",
          "n",
        },
        desc = "CopilotChat - Inline chat",
      },
      -- Custom input for CopilotChat
      {
        "<leader>ca",
        function()
          local input = vim.fn.input("Ask Copilot: ")
          if input ~= "" then
            vim.cmd("CopilotChat " .. input)
          end
        end,
        desc = "CopilotChat - Ask Copilot",
      },
      -- Quick chat with Copilot
      {
        "<leader>cq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            vim.cmd("CopilotChatBuffer " .. input)
          end
        end,
        desc = "CopilotChat - Quick chat",
      },
      -- Generate commit message based on the git diff
      {
        "<leader>cm",
        function()
          vim.cmd("CopilotChatCommit")
        end,
        desc = "CopilotChat - Generate commit message for all changes",
      },
      {
        "<leader>cM",
        function()
          vim.cmd("CopilotChatCommit")
        end,
        desc = "CopilotChat - Generate commit message for staged changes",
      },
      -- Debug
      {
        "<leader>cd",
        function()
          vim.cmd("CopilotChatDebugInfo")
        end,
        desc = "CopilotChat - Debug Info",
      },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      local select = require("CopilotChat.select")

      chat.setup(opts)

      -- Registers cmp source for CopilotChat and enables it
      require("CopilotChat.integrations.cmp").setup()

      vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
        -- if current filetype is copilot-chat, then close the chat window
        if vim.bo.filetype == "copilot-chat" then
          chat.close()
          return
        end

        -- get if in visual mode
        local is_visual = vim.api.nvim_get_mode().mode == "v" or vim.api.nvim_get_mode().mode == "V"

        print("has_visual", is_visual)

        chat.ask(args.args, {
          selection = function(source)
            if is_visual then
              return select.visual(source)
            end
          end,
        })
      end, { nargs = "*", range = true })

      -- Inline chat with Copilot
      vim.api.nvim_create_user_command("CopilotChatInline", function(args)
        chat.ask(args.args, {
          selection = select.visual,
          window = {
            layout = "float",
            relative = "cursor",
            width = 1,
            height = 0.4,
            row = 1,
          },
        })
      end, { nargs = "*", range = true })

      vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
        chat.ask(args.args, { selection = select.buffer })
      end, { nargs = "*", range = true })

      -- Custom buffer for CopilotChat
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })
    end,
  },
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.right = opts.right or {}
      table.insert(opts.right, {
        ft = "copilot-chat",
        title = "Copilot Chat",
        size = { width = 50 },
      })
    end,
  },
}
