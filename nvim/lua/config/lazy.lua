require("config.options")
require("config.commands")
require("config.keymaps")

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	install = {
		missing = not kokovim.is_nix,
	},
	change_detection = {
	  enabled = not kokovim.is_nix,
	},
	checker = {
	  enabled = not kokovim.is_nix
	},
})




