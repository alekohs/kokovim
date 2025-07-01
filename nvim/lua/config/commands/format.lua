local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local group = augroup("KokovimFormat", { clear = true })

-- Enable autoformat for specific filetypes
autocmd("FileType", {
  group = group,
  desc = "Activate auto format",
  pattern = { "nix", "lua" },
  callback = function() vim.b.autoformat = true end,
})

autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({
      bufnr = args.buf,
      lsp_fallback = true,
      async = false,
      timeout_ms = 1000,
      formatters = { "squeeze_blanks", "trim_whitespace", "trim_newlines" },
    })
  end,
})
