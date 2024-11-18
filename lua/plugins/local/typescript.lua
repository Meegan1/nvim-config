return {
  {
    "pmizio/typescript-tools.nvim",
    requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      require("typescript-tools").setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          -- inlay hints
          if vim.fn.has("nvim-0.10") == 1 then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end
        end,
        handlers = {
          ["textDocument/hover"] = function(err, result, method)
            -- get the current buffer
            local buf = vim.api.nvim_get_current_buf()

            -- get the current cursor position
            local row, col = unpack(vim.api.nvim_win_get_cursor(0))
            local pos_info = vim.inspect_pos(buf, row - 1, col)

            -- get diagnostics for the current line
            local line_diags = vim.diagnostic.get(buf, {
              lnum = pos_info.row,
            })

            -- filter diagnostics to only show the ones that are in the same column
            local diags = {}
            for i, diag in ipairs(line_diags) do
              if col >= diag.col and col <= diag.end_col then
                diags[#diags + 1] = diag
              end
            end

            -- convert result.contents to table if it's not already
            if result and result.contents and type(result.contents) ~= "table" then
              result.contents = { result.contents }
            end

            local diags_contents = {
              kind = "markdown",
              value = "",
            }

            -- if diags length > 0 then prepend Diagnostics:
            if #diags > 0 then
              if result and result.contents and #result.contents > 0 then
                diags_contents.value = diags_contents.value .. "\n---\n"
              end

              diags_contents.value = diags_contents.value .. "Diagnostics:"
            end

            for i, diag in ipairs(diags) do
              if col >= diag.col and col <= diag.end_col then
                diags_contents.value = diags_contents.value
                    .. "\n"
                    .. i
                    .. ". "
                    .. diag.message
                    .. " \\["
                    .. diag.code
                    .. "\\]"
              end
            end

            -- add contents to end of result.contents table
            if result and result.contents then
              table.insert(result.contents, diags_contents)
            end

            return vim.lsp.handlers["textDocument/hover"](err, result, method)
          end,
        },
        settings = {
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayVariableTypeHints = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = false,
            includeInlayEnumMemberValueHints = true,
          },
        },
      })
    end,
  },
}
