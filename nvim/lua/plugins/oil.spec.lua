local utils = require("utils")

return {
	-- "stevearc/oil.nvim",
	utils.getPlugin("oil.nvim", "stevearc/oil.nvim"),
	name = "oil.nvim",
	opts = {
		default_file_explorer = true,
	},
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	lazy = false,
}
