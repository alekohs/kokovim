local M = {}

local nixEnv = vim.fn.getenv("NVIM_NIX")
local function removeLastFolder(path) return path:match("(.+)/[^/]+/?$") end

M.appName = vim.fn.getenv("NVIM_APPNAME")

function M.isNixApp()
  return nixEnv == "1"
end

function M.getPlugin(localDir, github, config)
  config = config or {}

  local pathConfig = { github }
  if M.isNixApp() then
    local pack_paths = vim.api.nvim_list_runtime_paths()
    for _, path in ipairs(pack_paths) do
      if path:match("pack/myNeovimPackages/start") then
        -- print("Found pack dir: " .. path)
        -- print("Found pack dir: " .. removeLastFolder(path))
        localDir = removeLastFolder(path) .. "/" .. localDir
        -- print(localDir)
        break
      end
    end
    pathConfig = { dir = localDir }
  end

  local combinedConfig = {}
  for k in pairs(pathConfig) do
    combinedConfig[k] = pathConfig[k]
  end

  for k in pairs(config) do
    combinedConfig[k] = config[k]
  end

  -- for k in pairs(combinedConfig) do
  --   print(k .. " " .. tostring(combinedConfig[k]))
  -- end
  --sdfsd
  return combinedConfig
end

function M.root()
  local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result:gsub("%s+$", "") -- remove trailing newline
  end
end

return M
