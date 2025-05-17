local M = {}

local nixEnv = vim.fn.getenv("NVIM_NIX")

M.appName = vim.fn.getenv("NVIM_APPNAME")
M.isNix = nixEnv == "1"


function M.root()
  local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result:gsub("%s+$", "") -- remove trailing newline
  end
end

return M
