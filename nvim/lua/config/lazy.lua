local utils = require("utils")

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	install = {
		missing = not utils.isNix,
	},
	-- automatically check for plugin updates
	checker = { enabled = false },
})

require("config.options")
require("config.commands")
require("config.keymaps")


