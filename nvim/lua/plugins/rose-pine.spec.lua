local utils = require("utils")

return utils.get_plugin("rose-pine", "rose-pine/neovim", {
	name = "rose-pine",
	config = function()
		vim.cmd("colorscheme rose-pine")
	end,
})
