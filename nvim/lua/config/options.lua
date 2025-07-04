local opt = vim.opt


-- Clipboard
opt.clipboard = "unnamedplus"

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
opt.incsearch = true
opt.ignorecase = true
opt.linebreak = true
opt.mouse = "a"
opt.mousemodel = "extend"
opt.modeline = true
opt.modelines = 100
opt.number = true
opt.relativenumber = true
opt.scrolloff = 4
opt.shiftround = true
opt.shiftwidth = 2
opt.showmode = false
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.startofline = true
opt.showmatch = true
opt.synmaxcol = 240
opt.swapfile = false
opt.preserveindent = true
opt.tabstop = 2
opt.termguicolors = true
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 300
opt.virtualedit = "block"
opt.writebackup = false
opt.wildmode = { "longest:full", "full" }
opt.wrap = false

