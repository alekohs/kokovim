return kokovim.get_plugin_by_repo("stevearc/conform.nvim", {
  cmd = "ConformInfo",
  event = "VeryLazy",
  opts = {
    default_format_opts = {
      lsp_format = "fallback",
    },
    formatters_by_ft = {
      bash = { "shellcheck", "shellharden", "shfmt" },
      sh = { "shellcheck", "shellharden", "shfmt" },

      -- TODO: Update to use biome instead of prettier
      -- html = { "biome" },
      html = { "prettierd", "prettier", timeout_ms = 2000, stop_after_first = true },
      css = { "stylelint", "prettierd" },

      javascript = { "biome-check" },
      javascriptreact = { "biome-check" },
      typescript = { "biome-check" },
      typescriptreact = { "biome-check" },

      swift = { "swiftformat" },

      go = { "gofmt", "goimports" },

      json = { "biome-check", "jq", stop_after_first = true },
      jsonc = { "biome-check", "jq", stop_after_first = true },
      yaml = { "yamlfmt" },
      lua = { "stylua" },
      markdown = { "deno_fmt" },
      nix = { "nixfmt" },
      fish = { "fish_indent" },
      ps1 = { "powershell_es" },
      -- ["*"] = { "codespell" },
      ["_"] = { "squeeze_blanks", "trim_whitespace", "trim_newlines" },
    },
  },
  config = function(_, opts)
    require("conform").setup(opts)

    vim.api.nvim_create_user_command("FormatGlob", function()
      vim.ui.input({ prompt = "Enter pattern (e.g. **/*.tsx): " }, function(glob)
        if not glob or glob == "" then
          print("Aborted: no pattern provided.")
          return
        end

        local files = vim.fn.glob(glob, true, true)
        if vim.tbl_isempty(files) then
          print("No files matched glob: " .. glob)
          return
        end

        local conform = require("conform")

        for _, file in ipairs(files) do
          local bufnr = vim.fn.bufadd(file)
          vim.fn.bufload(bufnr)
          conform.format({ bufnr = bufnr, lsp_fallback = true })
          vim.api.nvim_buf_call(bufnr, function() vim.cmd("silent! write") end)
        end

        print("Formatted " .. #files .. " file(s).")
      end)
    end, {})
  end,
  keys = {
    { "<leader>cg", ":FormatGlob<CR>", mode = "n", silent = true, desc = "Format files by glob" },
    {
      "<leader>cf",
      function()
        require("conform").format({
          lsp_fallback = true,
        })
      end,
      mode = "n",
      desc = "Format injected language",
    },
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
