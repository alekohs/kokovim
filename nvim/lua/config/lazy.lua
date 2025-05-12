vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("nvim.lua.config.lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = {
		missing = false,
	},
	-- automatically check for plugin updates
	checker = { enabled = false },
})
