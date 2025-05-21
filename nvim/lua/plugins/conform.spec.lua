return kokovim.get_plugin_by_repo("stevearc/conform.nvim", {
  cmd = "ConformInfo",
  event = "VeryLazy",
  opts = {
    default_format_opts = {
      lsp_format = "fallback",
    },
    formatters_by_ft = {
      bash = { "shellcheck", "shellharden", "shfmt" },

      html = { "prettierd", "prettier", timeout_ms = 2000, stop_after_first = true },
      javascript = { "prettierd", "prettier", timeout_ms = 2000, stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", timeout_ms = 2000, stop_after_first = true },
      typescript = { "prettierd", "prettier", timeout_ms = 2000, stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", timeout_ms = 2000, stop_after_first = true },

      go = { "gofmt", "goimports" },

      json = { "jq" },
      yaml = { "yamlfmt" },
      lua = { "stylua" },
      markdown = { "deno_fmt" },
      nix = { "nixfmt" },
      fish = { "fish_indent" },
      ["*"] = { "codespell" },
      ["_"] = { "squeeze_blanks", "trim_whitespace", "trim_newlines" },
    },
  },
  config = function(_, opts) require("conform").setup(opts) end,
  keys = {
    { "<leader>cF", function() require("conform").format() end, mode = "n", desc = "Format injected language" },
    {
      "<leader>cF",
      function()
        require("conform").format({
          lsp_fallback = true,
          range = {
            ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
            ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
          },
        })
      end,
      mode = "v",
      desc = "Format injected language",
    },
  },
})
