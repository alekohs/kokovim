local opt = vim.opt

-- Clipboard
-- opt.clipboard = "unnamedplus"  -- Copy to the clipboard register

-- General
opt.autowrite = true
opt.autoindent = true
opt.breakindent = true
opt.completeopt = { "menu", "menuone", "noselect" }
opt.confirm = true
opt.cursorline = true
opt.copyindent = true
opt.expandtab = true
opt.foldlevel = 99
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""
opt.inccommand = "nosplit"
opt.incsearch = true
opt.ignorecase = true
opt.linebreak = true
opt.mouse = "a"
opt.mousemodel = "extend"
opt.modeline = true
opt.modelines = 100
opt.number = true
opt.relativenumber = true
opt.scrolloff = 8
opt.shiftround = true
opt.shiftwidth = 2
opt.showmode = false
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.smartcase = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.swapfile = false
opt.preserveindent = true
opt.tabstop = 2
opt.termguicolors = true
opt.undofile = true
opt.undolevels = 10000
opt.timeoutlen = 300
opt.updatetime = 300
opt.virtualedit = "block"
opt.writebackup = false
opt.wildmode = { "longest:full", "full" }
opt.wrap = false
opt.cmdheight = 0

vim.filetype.add({
  pattern = {
    [".*%.props"] = "xml",
  },
})
