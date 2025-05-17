local function configure_mason() end
local lsps = {
  "dockerls",
  "fish_lsp",
  "gopls",
  "graphql",
  "html",
  "lua_ls",
  "nixd",
  "pylsp",
  "sqlls",
  "rust_analyzer",
  "tailwindcss",
  "ziggy",
  "marksman",
}

return {
  {
    kokovim.get_plugin_by_repo("neovim/nvim-lspconfig", {
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        kokovim.get_plugin_by_repo("SmiteshP/nvim-navbuddy", {
          dependencies = {
            kokovim.get_plugin_by_repo("SmiteshP/nvim-navic"),
            kokovim.get_plugin_by_repo("MunifTanjim/nui.nvim"),
          },
          opts = { lsp = { auto_attach = true } },
        }),
      },
      opts = {
        servers = {
          lua_ls = {},
          ts_ls = {},
        },
      },
      config = function(_, opts)
        local lspconfig = require("lspconfig")
        local navic = require("nvim-navic")
        local navbuddy = require("nvim-navbuddy")

        -- Shared `on_attach` if you want keymaps, etc.
        local on_attach = function(client, bufnr)
          if client.server_capabilities.documentSymbolProvider then
            print("Load navic to the lsp")
            navic.attach(client, bufnr)
            navbuddy.attach(client, bufnr)
          end

          vim.keymap.set(
            "n",
            "<leader>ck",
            function() require("nvim-navbuddy").open() end,
            { desc = "Lsp Navigation", buffer = bufnr }
          )

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
        -- local capabilities = vim.lsp.protocol.make_client_capabilities()
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

        -- Loop all simple lsps
        for _, lsp in ipairs(lsps) do
          lspconfig[lsp].setup({ on_attach = on_attach, capabilities = capabilities })
        end

        lspconfig.ts_ls.setup({
          on_attach = function(client, bufnr)
            -- Disable ts_ls formatting if using prettier/eslint
            client.server_capabilities.documentFormattingProvider = false
            on_attach(client, bufnr)
          end,
          capabilities = capabilities,
          filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        })
      end,
    }),
  },
}
