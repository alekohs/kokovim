local utils = require("utils")
-- vim.keymap.set(
--   "gd",
--   "<cmd>FzfLua lsp_definitions jump1=true ignore_current_line=true<cr>",
--   { desc = "Goto Definition", has = "definition" }
-- )
-- vim.keymap.set(
--   "gr",
--   "<cmd>FzfLua lsp_references jump1=true ignore_current_line=true<cr>",
--   { desc = "References", nowait = true }
-- )
-- vim.keymap.set(
--   "gI",
--   "<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>",
--   { desc = "Goto Implementation" }
-- )
--
-- vim.keymap.set(
--   "gy",
--   "<cmd>FzfLua lsp_typedefs jump1=true ignore_current_line=true<cr>",
--   { desc = "Goto Type Definition" }
-- )
--
-- TODO Fix for none nix application
local function configure_mason() end

return {

  {
    utils.get_plugin("nvim-lspconfig", "neovim/nvim-lspconfig", {
      event = { "BufReadPre", "BufNewFile" },
      opts = {
        servers = {
          lua_ls = {},
        },
      },
      config = function(_, opts)
        local lspconfig = require("lspconfig")

        -- Shared `on_attach` if you want keymaps, etc.
        local on_attach = function(client, bufnr)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition", buffer = bufnr })
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation", buffer = bufnr })
          vim.keymap.set(
            { "n", "v" },
            "cf",
            vim.lsp.buf.format,
            { desc = "Format selection", silent = true, buffer = bufnr }
          )
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show buf hover", buffer = bufnr })
          vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename", buffer = bufnr })
        end

        -- Shared capabilities (for blink-cmp etc.)
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))
        capabilities = vim.tbl_deep_extend("force", capabilities, {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            },
          },
        })
        -- local capabilities = vim.lsp.protocol.make_client_capabilities()

        lspconfig.lua_ls.setup({
          on_attach = on_attach,
          capabilities = capabilities,
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        })

        lspconfig.nixd.setup({ on_attach = on_attach, capabilities = capabilities })

        lspconfig.tsserver.setup({
          on_attach = function(client, bufnr)
            -- Disable tsserver formatting if using prettier/eslint
            client.server_capabilities.documentFormattingProvider = false
            on_attach(client, bufnr)
          end,
          capabilities = capabilities,
          filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },

          -- Optional: if typescript-language-server is not in PATH
          -- cmd = { "typescript-language-server", "--stdio" },
        })
      end,
    }),
  },
}
