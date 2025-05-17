local utils = require('kokovim.utils')
local plugin = require('kokovim.plugin')

-- print("Loaded app '" .. utils.appName .. "' with nix: " .. tostring(utils.isNix()))

local M = {}
M.isNix = utils.isNix

function M.get_plugin(localDir, github, config)
  return plugin.get_plugin(localDir, github, config)
end


-- Define the globals under kokovim
_G.kokovim = M
