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

--- Get colorscheme picker
M.theme_picker = function()
  local themes = vim.fn.getcompletion("", "color") -- list all colorschemes
  local fzf = require("fzf-lua")

  fzf.fzf_exec(themes, {
    prompt = "Colorschemes> ",
    previewer = function(entry)
      if entry == nil then return "" end

      local theme = selected[1]
      if not theme then return "" end

      -- apply the colorscheme temporarily to a buffer preview
      -- create a small snippet showing some highlights
      local lines = {
        "Normal text",
        "Comment text",
        "String text",
        "Function text",
      }

      -- apply colorscheme temporarily (without affecting user buffer)
      vim.cmd("silent colorscheme " .. theme)

      -- format the lines to show highlight groups
      local result = {}
      for _, line in ipairs(lines) do
        table.insert(result, line)
      end
      return table.concat(result, "\n")
    end,
    actions = {
      ["default"] = function(selected) vim.cmd("colorscheme " .. selected[1]) end,
    },
    on_move = function(selected) print("Movement" .. selected) end,
  })
end

--- Get harpoon picker
M.harpoon_fzf = function(files, cb)
  local file_paths = {}
  local index_map = {}

  for idx, item in ipairs(files.items) do
    local full_path = vim.fn.fnamemodify(item.value, ":p")
    local display = string.format("%d: %s", idx, item.value)
    table.insert(file_paths, display)
    index_map[display] = full_path
  end

  local fzf = require("fzf-lua")

  local builtin = require("fzf-lua.previewer.builtin")
  local HarpoonPreviewer = builtin.buffer_or_file:extend()

  function HarpoonPreviewer:new(o, opts, fzf_win)
    HarpoonPreviewer.super.new(self, o, opts, fzf_win)
    setmetatable(self, HarpoonPreviewer)
    return self
  end

  function HarpoonPreviewer:parse_entry(entry_str)
    local idx, _ = entry_str:match("^(%d+):%s*(.+)$")
    local path = index_map[entry_str]

    return {
      path = path,
      line = tonumber(idx) or 1,
      col = 1,
    }
  end
  fzf.fzf_exec(file_paths, {
    prompt = "Harpoon> ",
    previewer = HarpoonPreviewer,
    fzf_opts = {
      ["--preview-window"] = "nohidden,right,50%",
      -- ["--delimiter"] = [[\\.]],
      ["--ansi"] = "",
      ["--nth"] = "3..",
    },
    actions = {
      ["default"] = function(selected, _)
        if selected and selected[1] then
          local line = vim.trim(selected[1])
          local idx, _ = line:match("^(%d+):%s*(.+)$")

          if cb == nil then
            local harpoon = require("harpoon")
            harpoon:list():select(tonumber(idx))
          else
            cb(tonumber(idx))
          end
        end
      end,
    },
  })
end

return M
