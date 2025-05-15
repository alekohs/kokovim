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
  -- event = "LazyFile",
  opts = function() end,
  config = function(_, opts) end,
})
