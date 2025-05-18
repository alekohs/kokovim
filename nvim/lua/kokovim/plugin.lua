local utils = require("kokovim.utils")
local M = {}
local function removeLastFolder(path) return path:match("(.+)/[^/]+/?$") end

function M.get_plugin(local_dir, github, config)
  config = config or {}

  local path_config = { github }
  if utils.is_nix then
    local pack_paths = vim.api.nvim_list_runtime_paths()
    for _, path in ipairs(pack_paths) do
      if path:match("pack/myNeovimPackages/start") then
        -- print("Found pack dir: " .. path)
        -- print("Found pack dir: " .. removeLastFolder(path))
        local_dir = removeLastFolder(path) .. "/" .. local_dir
        -- print(localDir)
        break
      end
    end
    path_config = { dir = local_dir }
  end

  local combined_config = {}
  for k in pairs(path_config) do
    combined_config[k] = path_config[k]
  end

  for k in pairs(config) do
    combined_config[k] = config[k]
  end

  -- for k in pairs(combinedConfig) do
  --   print(k .. " " .. tostring(combinedConfig[k]))
  -- end
  --sdfsd
  return combined_config
end

return M

