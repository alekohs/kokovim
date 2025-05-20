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

-- Remove trailing whitespace on save
autocmd("BufWrite", {
  group = group,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})
