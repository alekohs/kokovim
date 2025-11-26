local M = {}

--- Get colorscheme picker
---@return string Colorscheme
M.theme_picker = function()
  local themes = vim.fn.getcompletion("", "color") -- list all colorschemes

  -- Use FZF to pick one
  local fzf = require("fzf-lua")
  local preview = function(theme) return "hi Normal guifg=white guibg=black | colorscheme " .. theme end

  fzf(themes, {
    prompt = "Colorscheme> ",
    preview = preview,
    actions = {
      ["default"] = function(selected) vim.cmd("colorscheme " .. selected[1]) end,
    },
  })
end

return M
