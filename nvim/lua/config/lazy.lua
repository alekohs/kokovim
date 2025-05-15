vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local utils = require("utils")

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	install = {
		missing = not utils.isNixApp(),
	},
	-- automatically check for plugin updates
	checker = { enabled = false },
})
