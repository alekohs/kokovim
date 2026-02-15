local lsps = {
  "cssls",
  "dockerls",
  "fish_lsp",
  "gopls",
  "graphql",
  "lua_ls",
  "nixd",
  "sqlls",
  "rust_analyzer",
  "tailwindcss",
  "taplo",
  "yamlls",
  "ziggy",
  "marksman",
  "powershell_es",
}

return {
  require("plugins.lsp.dotnet"),
  kokovim.get_plugin_by_repo("rachartier/tiny-inline-diagnostic.nvim", {
    event = "VeryLazy",
    priority = 1000,
    opts = {
      options = {
        set_arrow_to_diag_color = true,
      },
    },
  }),
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
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "", -- Error
            [vim.diagnostic.severity.WARN] = "", -- Warning
            [vim.diagnostic.severity.HINT] = "", -- Hint
            [vim.diagnostic.severity.INFO] = "", -- Info
          },
        },
      },
      inlay_hints = {
        enabled = true,
        exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints (cs/razor handled by autocmd)
      },
      servers = {
        lua_ls = {},
        ts_ls = {},
      },
    },
    config = function(_, opts)
      local navic = require("nvim-navic")
      local navbuddy = require("nvim-navbuddy")

      -- Shared `on_attach` if you want keymaps, etc.
      local on_attach = function(client, bufnr)
        -- Stop if buftype is empty
        local bt = vim.api.nvim_buf_get_option(bufnr, "buftype")
        if bt ~= "" and client.name ~= "html" then
          client.stop()
          return
        end

        if client.server_capabilities.documentSymbolProvider then
          local dominated = client.name == "html" and vim.bo[bufnr].filetype == "razor"
          if not dominated then
            vim.notify("Attach navic to buffer", vim.log.levels.DEBUG)
            navic.attach(client, bufnr)
            navbuddy.attach(client, bufnr)
          end
        end

        vim.keymap.set("n", "<leader>ck", function() require("nvim-navbuddy").open() end, { desc = "Lsp Navigation", buffer = bufnr })
        vim.keymap.set("n", "<leader>cP", function()
          for _, client in ipairs(vim.lsp.get_active_clients()) do
            print("Client:", client.name)
            for _, bufnr in ipairs(client.buffers) do
              print(" - Buffer:", bufnr, "File:", vim.api.nvim_buf_get_name(bufnr))
            end
          end
        end, { desc = "Lsp Navigation", buffer = bufnr })
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

      -- Loop all simple lsps
      for _, lsp in ipairs(lsps) do
        vim.lsp.config(lsp, {
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end

      ---
      --- Bash
      ---
      vim.lsp.config("bashls", {
        filetypes = { "sh", "bash" },
        cmd = { "bash-language-server", "start" },
        on_attach = on_attach,
        capabilities = capabilities,
      })

      ---
      --- HTML
      ---
      vim.lsp.config("html", {
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "html", "razor" },
        init_options = {
          configurationSection = { "html", "css", "javascript" },
          embeddedLanguages = { css = true, javascript = true },
          provideFormatter = true,
        },
      })

      ---
      --- Python
      ---
      vim.lsp.config("pylsp", {
        filetypes = { "python" },
        cmd = { "pylsp" },
        on_attach = on_attach,
        capabilities = capabilities,
      })

      --
      -- Javascript/Typescript
      --
      vim.lsp.config("ts_ls", {
        on_attach = function(client, bufnr)
          -- Disable ts_ls formatting if using prettier/eslint
          client.server_capabilities.documentFormattingProvider = false
          on_attach(client, bufnr)
        end,
        capabilities = capabilities,
        filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
      })

      --
      -- Swift / Xcode
      --
      vim.lsp.config("sourcekit", {
        cmd = { "xcrun", "sourcekit-lsp" },
        root = function(filename)
          local util = require("lspconfig.util")
          return util.root_pattern("buildServer.json")(filename)
            or util.root_pattern("*.xcodeproj", "*.xcworkspace")(filename)
            or util.find_git_ancestor(filename)
            or util.root_pattern("Package.swift")
        end,
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- Roslyn settings are configured in roslyn.nvim (plugins/lsp/dotnet.lua)
      vim.lsp.config("roslyn", {
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- On Nix, mason-lspconfig is disabled so we must enable servers ourselves
      if kokovim.is_nix then
        local all_servers = vim.list_extend(
          vim.deepcopy(lsps),
          { "bashls", "html", "pylsp", "ts_ls", "sourcekit", "roslyn" }
        )
        vim.lsp.enable(all_servers)
      end

      -- Configure diaganostics
      vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = false,
        signs = opts.diagnostics.signs,
      })
    end,
    keys = {
      { "gd", function() require("fzf-lua").lsp_definitions() end, mode = "n", desc = "Goto definition", silent = true },
      { "gD", function() require("fzf-lua").lsp_declarations() end, mode = "n", desc = "Goto declaration" },
      { "gi", function() require("fzf-lua").lsp_implementations() end, mode = "n", desc = "Goto Implementations" },
      { "gy", function() require("fzf-lua").lsp_typedefs() end, mode = "n", desc = "Goto T[y]pe Definition" },
      { "gr", function() require("fzf-lua").lsp_references() end, mode = "n", desc = "References", silent = true },
      { "<leader>ca", function() vim.lsp.buf.code_action() end, mode = "n", desc = "Code Action" },
      {
        "<leader>cA",
        function()
          vim.lsp.buf.code_action({
            apply = true,
            context = { only = { "source" }, diagnostics = {} },
          })
        end,
        desc = "Source Action",
      },

      { "<leader>cc", function() vim.lsp.codelens.run() end, mode = "n", desc = "Run Codelens" },
      { "<leader>cC", function() vim.lsp.codelens.refresh() end, mode = "n", desc = "Refresh Codelens" },
      { "<leader>cF", function() vim.lsp.buf.format() end, mode = "n", desc = "Format code with LSP" },

      { "K", function() return vim.lsp.buf.hover({ border = "rounded" }) end, mode = "n", desc = "Hover" },
      { "<leader>gK", function() return vim.lsp.buf.signature_help() end, mode = "n", desc = "Signature help" },
      { "<C-k>", function() return vim.lsp.buf.signature_help() end, mode = "i", desc = "Signature help" },
      { "<leader>cr", vim.lsp.buf.rename, mode = "n", desc = "Rename" },
      -- Note: fzf-lua does not have rename_file by default, so this is left as a no-op or custom function:
      -- Replace with your own file rename function or plugin if needed:
      {
        "<leader>cR",
        function() print("Rename File: Implement your custom rename here") end,
        mode = "n",
        desc = "Rename File",
      },
    },
  }),
  kokovim.get_plugin_by_repo("danymat/neogen", {
    opts = {
      snippet_engine = "mini",
      languages = {
        cs = {
          template = {
            annotation_convention = "xmldoc",
          },
        },
      },
    },
    config = function(_, opts) require("neogen").setup(opts) end,
    keys = {
      { "<leader>cn", "<CMD>Neogen<CR>", desc = "Generate annotation" },
    },
  }),
}
