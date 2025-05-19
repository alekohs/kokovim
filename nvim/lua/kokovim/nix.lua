local utils = require("kokovim.utils")

-- Make some changes if the system isn't nix
if not utils.is_nix then
  local rtp = vim.opt.runtimepath:get()
  -- Filter out any path that contains "/nix"
  local clean_rtp = vim.tbl_filter(function(path) return not path:find("/nix", 1, true) end, rtp)

  -- DEBUG
  -- Filter out any path that contains "/nix"
  -- for _, path in ipairs(rtp) do
  --   if path:find("/nix", 1, true) then print("Removing: " .. path) end
  -- end

  -- vim.opt.runtimepath = table.concat(clean_rtp, ",")
end

-- vim.opt.rtp:prepend(plugins_path)
