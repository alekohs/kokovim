local utils = require("utils")

return {
	-- "rose-pine/neovim",
	utils.getPlugin("rose-pine", "rose-pine/neovim"),
	name = "rose-pine",
	config = function()
		vim.cmd("colorscheme rose-pine")
	end,
}
