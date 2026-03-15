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
      ["default"] = function(selected, opts)
        print(opts)
        local selection = selected[1]
        callback(selection)
      end,
    },
  })
end

return M
