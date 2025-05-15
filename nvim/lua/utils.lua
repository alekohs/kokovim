local M = {}

local nixEnv = os.getenv("NVIM_NIX")

M.getAppName = function()
  return os.getenv("NVIM_APPNAME")
end

M.isNixApp = function()
  return nixEnv == "1"
end

M.getPlugin = function(localDir, github)
  if M.isNixApp() then
    return "/nix/store/ik2n7m2b3b8dfp7kpn902133pah0f1af-vim-pack-dir/pack/myNeovimPackages/start/" .. localDir
  end

  return github
end


return M
