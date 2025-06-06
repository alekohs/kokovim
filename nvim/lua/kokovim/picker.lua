local M = {}

---@brief Open a harpoon in fzf-lua picker
--- @param list table
function M.harpoon_fzf(list)
  local fzf = require("fzf-lua")

  local items = {}
  for _, item in ipairs(list.items) do
    table.insert(items, item.value)
  end

  fzf.fzf_exec(items, {
    prompt = "Harpoon Files> ",
    previewer = "builtin",
    actions = {
      ["default"] = function(selected)
        local file = selected[1]
        vim.cmd("edit " .. file)
      end
    },
  })
end

return M
