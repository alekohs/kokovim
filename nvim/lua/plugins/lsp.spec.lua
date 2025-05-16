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

return utils.getPlugin("nvim-lspconfig", "neovim/nvim-lspconfig", {
  event = { "BufReadPre", "BufNewFile" },
  opts = function() end,
  config = function(_, opts)
    local lspconfig = require("lspconfig")

    -- Shared `on_attach` if you want keymaps, etc.
    local on_attach = function(client, bufnr)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
    end

    -- Shared capabilities (for nvim-cmp etc.)
    local capabilities = vim.lsp.protocol.make_client_capabilities()

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

  end,
})
