require("kokovim.nix")
require("kokovim.globals")
require("config.globals")
require("config.lazy")

-- Set transparent color and use terminal colors if transparent is chosen
local color = kokovim.get_colorscheme()
if color == "transparent" then
  vim.opt.termguicolors = false
  vim.cmd("syntax off")
  vim.opt.background = nil
  vim.cmd("highlight clear")
else
  vim.cmd("set background=dark")
  vim.cmd("colorscheme " .. color)
end
