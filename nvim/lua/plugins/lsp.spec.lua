local lsps = {
  "cssls",
  "dockerls",
  "fish_lsp",
  "gopls",
  "graphql",
  "lua_ls",
  "nixd",
  "jsonls",
  "sqlls",
  "rust_analyzer",
  "tailwindcss",
  "taplo",
  "lemminx",
  "yamlls",
  "ziggy",
  "markdown_oxide",
  "powershell_es",
}

local function rename_file()
  local bufnr = vim.api.nvim_get_current_buf()
  local old_name = vim.api.nvim_buf_get_name(bufnr)

  if old_name == "" then
    vim.notify("Current buffer has no file name", vim.log.levels.WARN)
    return
  end

  old_name = vim.fs.normalize(old_name)

  vim.ui.input({ prompt = "New path: ", default = old_name, completion = "file" }, function(input)
    if not input or input == "" then return end

    local new_name = vim.fs.normalize(vim.fn.fnamemodify(input, ":p"))
    if new_name == old_name then return end

    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    local params = {
      files = {
        {
          oldUri = vim.uri_from_fname(old_name),
          newUri = vim.uri_from_fname(new_name),
        },
      },
    }

    for _, client in ipairs(clients) do
      if client:supports_method("workspace/willRenameFiles") then
        local response = client:request_sync("workspace/willRenameFiles", params, 1000, bufnr)
        if response and response.result then
          vim.lsp.util.apply_workspace_edit(response.result, client.offset_encoding)
        end
      end
    end

    vim.lsp.util.rename(old_name, new_name)

    for _, client in ipairs(clients) do
      if client:supports_method("workspace/didRenameFiles") then
        client:notify("workspace/didRenameFiles", params)
      end
    end
  end)
end

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
      kokovim.get_plugin_by_repo("SmiteshP/nvim-navic"),
    },
    opts = {
      diagnostics = {
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = kokovim.icons.diagnostics.error,
            [vim.diagnostic.severity.WARN]  = kokovim.icons.diagnostics.warn,
            [vim.diagnostic.severity.HINT]  = kokovim.icons.diagnostics.hint,
            [vim.diagnostic.severity.INFO]  = kokovim.icons.diagnostics.info,
          },
        },
      },
    },
    config = function(_, opts)
      local common = require("plugins.lsp.common")
      local on_attach = common.on_attach
      local capabilities = common.capabilities()

      -- Global defaults for all servers
      vim.lsp.config("*", {
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- Bash
      vim.lsp.config("bashls", {
        filetypes = { "sh", "bash" },
        cmd = { "bash-language-server", "start" },
      })

      -- HTML
      vim.lsp.config("html", {
        filetypes = { "html", "razor" },
        init_options = {
          configurationSection = { "html", "css", "javascript" },
          embeddedLanguages = { css = true, javascript = true },
          provideFormatter = true,
        },
      })

      -- Python
      vim.lsp.config("pylsp", {
        filetypes = { "python" },
        cmd = { "pylsp" },
      })

      vim.lsp.config("qmlls", {
        filetypes = { "qml" },
        root_markers = { "qmldir", ".qmlproject", "CMakeLists.txt", ".git" },
      })

      -- Javascript/Typescript
      vim.lsp.config("ts_ls", {
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          on_attach(client, bufnr)
        end,
        filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
      })

      -- Rust
      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            completion = {
              limit = 25,
              fullFunctionSignatures = { enable = false },
              callable = { snippets = "none" },
            },
          },
        },
      })

      -- Swift / Xcode
      vim.lsp.config("sourcekit", {
        cmd = { "xcrun", "sourcekit-lsp" },
        root = function(filename)
          return vim.fs.root(filename, { "buildServer.json", "Package.swift", ".git" })
            or vim.fs.root(filename, function(name)
              return name:match("%.xcodeproj$") or name:match("%.xcworkspace$")
            end)
        end,
      })

      -- On Nix, mason-lspconfig is disabled so we must enable servers ourselves
      if kokovim.is_nix then
        local all_servers = vim.list_extend(vim.deepcopy(lsps), { "bashls", "html", "pylsp", "qmlls", "ts_ls", "sourcekit", "roslyn" })
        vim.lsp.enable(all_servers)
      end

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

      { "K", function() vim.lsp.buf.hover({ border = "rounded", max_width = math.floor(vim.o.columns * 0.8) }) end, mode = "n", desc = "Hover" },
      { "<leader>gK", function() return vim.lsp.buf.signature_help() end, mode = "n", desc = "Signature help" },
      { "<C-k>", function() return vim.lsp.buf.signature_help() end, mode = "i", desc = "Signature help" },
      { "<leader>cr", vim.lsp.buf.rename, mode = "n", desc = "Rename" },
      {
        "<leader>cR",
        rename_file,
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
