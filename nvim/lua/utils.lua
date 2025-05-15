local M = {}

M.getAppName = function()
  return os.getenv("NVIM_APPNAME")
end

M.isNixApp = function()
  local nixEnv = os.getenv("NVIM_NIX")
  return nixEnv == "1"
end


return M
