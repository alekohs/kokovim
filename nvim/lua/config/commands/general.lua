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
  callback = function() vim.hl.on_yank() end,
})

-- Enable treesitter highlighting for all filetypes except ones with conflicting built-in syntax
local ts_excluded = { help = true, man = true, checkhealth = true }
autocmd("FileType", {
  pattern = "*",
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    if ts_excluded[ft] then return end

    local lang = vim.treesitter.language.get_lang(ft) or ft
    local has_parser = pcall(vim.treesitter.language.inspect, lang)

    if has_parser then
      pcall(vim.treesitter.start, args.buf)
    elseif not kokovim.is_nix then
      local ok, nts = pcall(require, "nvim-treesitter")
      if ok and nts.install and require("nvim-treesitter.parsers")[lang] then
        nts.install({ lang }):wait(30000)
        pcall(vim.treesitter.start, args.buf)
      end
    end
  end,
})
