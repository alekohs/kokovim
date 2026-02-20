local utils = require("kokovim.utils")
local plugin = require("kokovim.plugin")

local M = {}
-- Check if current runtime is loaded through nix
M.is_nix = utils.is_nix
M.is_darwin = utils.get_uname() == "Darwin"

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

--- Get color scheme
---@return string (colorscheme)
function M.get_colorscheme()
  local color = os.getenv("KOKOVIM_COLOR")
  if color == nil or color == "" then color = "transparent" end

  return color
end

M.icons = {
  diagnostics = {
    error = "󰅖", -- nf-md-close  (small “x”)
    warn  = "", -- nf-md-alert
    hint  = "", -- nf-md-lightbulb
    info  = "", -- nf-md-information
  },
  git = {
    added     = "", -- nf-oct-diff_
    modified  = "",
    removed   = "",
    renamed   = "",
    untracked = "",
    ignored   = "",
    unmerged  = "",
  },
}

-- Define the globals under kokovim
_G.kokovim = M
