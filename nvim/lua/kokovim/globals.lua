local utils = require('kokovim.utils')
local plugin = require('kokovim.plugin')

-- print("Loaded app '" .. utils.appName .. "' with nix: " .. tostring(utils.isNix()))

local M = {}
-- Check if current runtime is loaded through nix
M.isNix = utils.isNix

--- Retrieves a plugin based on the provided parameters.
-- @param localDir (string|nil) Optional. The local directory name. Defaults to the repository name or ".".
-- @param github (string) The GitHub repository in the format "owner/repo".
-- @param config (table|nil) Optional. Configuration table for the plugin. Defaults to an empty table.
function M.get_plugin(localDir, github, config)
  localDir = localDir or github:match(".*/(.*)") or "."
  return plugin.get_plugin(localDir, github, config)
end

--- Retrieves a plugin based on the provided parameters.
-- @param github (string) The GitHub repository in the format "owner/repo".
-- @param config (table|nil) Optional. Configuration table for the plugin. Defaults to an empty table.
function M.get_plugin_by_repo(github, config)
  local localDir = github:match(".*/(.*)") or "."
  return plugin.get_plugin(localDir, github, config)
end


-- Define the globals under kokovim
_G.kokovim = M
