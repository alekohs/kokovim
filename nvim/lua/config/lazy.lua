
require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	install = {
		missing = not kokovim.isNix,
	},
	-- automatically check for plugin updates
	checker = { enabled = false },
})

require("config.options")
require("config.commands")
require("config.keymaps")


