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
        exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
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
        if bt ~= "" then
          client.stop()
          return
        end

        if client.server_capabilities.documentSymbolProvider then
          vim.notify("Attach navic to buffer", vim.log.levels.DEBUG)
          navic.attach(client, bufnr)
          navbuddy.attach(client, bufnr)
        end

        vim.keymap.set("n", "<leader>ck", function() require("nvim-navbuddy").open() end, { desc = "Lsp Navigation", buffer = bufnr })
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
        filetypes = { "html" },
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

      vim.lsp.config("roslyn", {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          ["csharp|completion"] = {
            dotnet_provide_regex_completions = true,
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_show_name_completion_suggestions = true,
          },
          ["csharp|formatting"] = {
            dotnet_organize_imports_on_format = true,
          },
          ["csharp|symbol_search"] = {
            dotnet_search_reference_assemblies = true,
          },

          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,

            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
            dotnet_enable_tests_code_lens = true,
          },
        },
      })

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
