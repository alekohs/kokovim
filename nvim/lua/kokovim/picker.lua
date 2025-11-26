local M = {}

--- Custom picker
---@return string Prompt
---@return string[] Options
M.fzf_picker = function(prompt, options, callback)
  local fzf = require("fzf-lua")
  fzf.fzf_exec(options, {
    prompt = prompt,
    previewer = "builtin",
    actions = {
      ["default"] = function(selected)
        local selection = selected[1]
        callback(selection)
      end,
    },
  })
end

--- Get colorscheme picker
---@return string Colorscheme
M.theme_picker = function()
  local themes = vim.fn.getcompletion("", "color") -- list all colorschemes

  -- Use FZF to pick one
  local fzf = require("fzf-lua")
  local preview = function(theme) return "hi Normal guifg=white guibg=black | colorscheme " .. theme end

  fzf.fzf_exec(themes, {
    prompt = "> ",
    winopts = {
      title = "Colorschemes"
    },
    preview = preview,
    actions = {
      ["default"] = function(selected) vim.cmd("colorscheme " .. selected[1]) end,
    },
  })
end

return M
