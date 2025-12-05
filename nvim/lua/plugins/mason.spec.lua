if kokovim.is_nix then return {} end

return {
  kokovim.get_plugin_by_repo("mason-org/mason.nvim", {
    opts = {
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
    },
  }),
  kokovim.get_plugin_by_repo("WhoIsSethDaniel/mason-tool-installer.nvim", {
    opts = {
      ensure_installed = {
        "jq",

        -- LSP
        "bash-language-server",
        { "docker-language-server", condition = function() return vim.fn.executable("docker") == 1 or vim.fn.executable("podman") == 1 end },
        { "gopls", condition = function() return vim.fn.executable("go") == 1 end },
        "fish-lsp",
        "html-lsp",
        "lua-language-server",
        "vim-language-server",
        "marksman",
        "yaml-language-server",
        "taplo",
        "rust-analyzer",
        "tailwindcss-language-server",
        "typescript-language-server",
        "python-lsp-server",
        "sqls",
        "qmlls",
        { "roslyn", condition = function() return vim.fn.executable("dotnet") == 1 end },
        { "powershell_es", condition = function() return vim.fn.executable("pwsh") == 1 end },

        -- Formatters
        "stylua",
        "codespell",
        "deno",
        "prettierd",
        "ruff",
        "stylua",
        "shfmt",
        "yamlfmt",

        -- LINT
        "jsonlint",
        "markdownlint-cli2",
        "markdownlint",
        "biome",
        "htmlhint",
        "stylelint",
        "yamllint",
        "editorconfig-checker",
        "shellcheck",
        "sqlfluff",
      },
    },
  }),

  kokovim.get_plugin_by_repo("mason-org/mason-lspconfig.nvim", {
    opts = {},
    dependencies = {
      kokovim.get_plugin_by_repo("mason-org/mason.nvim"),
      -- kokovim.get_plugin_by_repo("neovim/nvim-lspconfig"")
    },
  }),
}
