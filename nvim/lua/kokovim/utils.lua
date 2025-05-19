local M = {}

local nix_env = vim.fn.getenv("NVIM_NIX")
local nix_paths = vim.fn.getenv("NVIM_PACKAGES")

--- Get nvim app name
M.app_name = vim.fn.getenv("NVIM_APPNAME")

--- Check if app runs in nix mode
M.is_nix = nix_env == "1"

-- Get nix plugins path
M.nix_plugins = vim.fn.getenv("NVIM_PLUGINS_RP")

-- Use ssh for lazy.nvim
M.lazy_use_ssh = vim.fn.getenv("NVIM_PLUGINS_SSH") == "1"

--- Get package path from nix store
---@param package string
---@return string
function M.get_package_path(package)
  local lua_table_string = nix_paths:gsub("(%w+):", "%1 =")
  local lua_code = "return " .. lua_table_string

  print(lua_code)
  local success, result = pcall(load(lua_code))

  if success and type(result) == "table" then
    print(result[package])
    return result[package]
  end

  print("Error parsing JSON: ", result)
  return nil
end

--- Get root path
function M.root()
  local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result:gsub("%s+$", "") -- remove trailing newline
  end
end

return M
