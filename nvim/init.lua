require("kokovim.nix")
require("kokovim.globals")
require("config.globals")
require("config.lazy")

-- Use TTY-only mode when KOKOVIM_TTY is set, otherwise load rose-pine
if os.getenv("KOKOVIM_TTY") then
  vim.opt.termguicolors = false
  vim.cmd("syntax off")
  vim.opt.background = nil
  vim.cmd("highlight clear")
else
  vim.cmd("set background=dark")
  vim.cmd("colorscheme rose-pine")

  -- Clear background colors so the terminal background shows through
  local clear_bg_groups = {
    "Normal", "NormalNC", "NormalFloat",
    "SignColumn", "LineNr", "CursorLineNr",
    "StatusLine", "StatusLineNC",
    "TabLine", "TabLineFill",
    "WinBar", "WinBarNC",
    "WinSeparator", "VertSplit",
    "Folded", "FoldColumn",
    "DiagnosticSignError", "DiagnosticSignWarn", "DiagnosticSignInfo", "DiagnosticSignHint",
  }
  for _, group in ipairs(clear_bg_groups) do
    local hl = vim.api.nvim_get_hl(0, { name = group })
    hl.bg = nil
    hl.ctermbg = nil
    vim.api.nvim_set_hl(0, group, hl)
  end
end
