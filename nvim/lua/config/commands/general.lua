local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local group = augroup("KokovimGeneral", { clear = true })

autocmd("FileType", {
  group = group,
  pattern = { "tex", "latex", "markdown" },
  command = "setlocal spell spelllang=en_us"
})

-- Close filetypes with 'q'
autocmd("FileType", {
  group = group,
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
    "codecompanion",
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
  group = group,
  desc = "Highlight on yank",
  pattern = "*",
  callback = function() (vim.hl or vim.hl).on_yank() end,
})

