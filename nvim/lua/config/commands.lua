local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Group for general autocmds
local general = augroup("GeneralAutocmds", { clear = true })

-- Close filetypes with 'q'
autocmd("FileType", {
  group = general,
  desc = "Close filetypes with q",
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "oil",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- Highlight on yank
autocmd("TextYankPost", {
  group = general,
  desc = "Highlight on yank",
  pattern = "*",
  callback = function()
    (vim.highlight or vim.hl).on_yank()
  end,
})

-- Enable autoformat for specific filetypes
autocmd("FileType", {
  group = general,
  desc = "Activate auto format",
  pattern = { "nix", "lua" },
  callback = function()
    vim.b.autoformat = true
  end,
})

-- Remove trailing whitespace on save
autocmd("BufWrite", {
  group = general,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Set tab width to 4 for C# and Razor files
-- autocmd("FileType", {
--   group = general,
--   pattern = { "cs", "razor" },
--   command = "setlocal tabstop=4 shiftwidth=4",
-- })

-- -- Lint on save or insert leave
-- autocmd({ "BufWritePost", "InsertLeave" }, {
--   group = general,
--   desc = "Lint file",
--   pattern = "*",
--   callback = function()
--     require("lint").try_lint()
--   end,
-- })

