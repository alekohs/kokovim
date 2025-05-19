local utils = require("kokovim.utils")

local M = {}

local function removeLastFolder(path) return path:match("(.+)/[^/]+/?$") end

--- Get plugin folder from runtime
---@return folder string Folder path to plugins
function M.get_plugin_folder()
  local folder = ""
  local pack_paths = vim.api.nvim_list_runtime_paths()

  for _, path in ipairs(pack_paths) do
    if path:match("pack/myNeovimPackages/start") then
      folder = removeLastFolder(path) .. "/"
      break
    end
  end

  return folder
end

function M.get_plugin(local_dir, github, config)
  config = config or {}
  local path_config = { github }

  if utils.lazy_use_ssh then path_config["url"] = "git@github.com:" .. github end

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
  for k, v in pairs(path_config) do
    combined_config[k] = v
  end

  for k, v in pairs(config) do
    combined_config[k] = v
  end

  -- DEBUG
  -- for k in pairs(combinedConfig) do
  --   print(k .. " " .. tostring(combinedConfig[k]))
  -- end
  --
  --
  --
  -- print(vim.inspect(combined_config))
  --
  return combined_config
end

return M
