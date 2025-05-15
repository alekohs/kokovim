vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local utils = require("utils")

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- { import = "plugins" },
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = {
		missing = not utils.isNixApp(),
	},
	-- automatically check for plugin updates
	checker = { enabled = false },
})
