local M = {}

local nixEnv = vim.fn.getenv("NVIM_NIX")

M.app_name = vim.fn.getenv("NVIM_APPNAME")
M.is_nix = nixEnv == "1"
M.nix_plugins = vim.fn.getenv("NVIM_PLUGINS_RP")
M.lazy_use_ssh = vim.fn.getenv("NVIM_PLUGINS_SSH") == "1"


function M.root()
  local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result:gsub("%s+$", "") -- remove trailing newline
  end
end

return M
