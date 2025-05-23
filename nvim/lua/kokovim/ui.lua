local M = {}

--- Create a custom colored prompt for temporary usage
---@param prompt string Prompt text
---@param overrides table Overrides for the float and border
---@param callback function Callback to run after the prompt
function M.custom_prompt(prompt, overrides, callback)

  -- Save original values
  local original_float = vim.api.nvim_get_hl_by_name("NormalFloat", true)
  local original_border = vim.api.nvim_get_hl_by_name("FloatBorder", true)

  if overrides.NormalFloat then vim.api.nvim_set_hl(0, "NormalFloat", overrides.NormalFloat) end
  if overrides.FloatBorder then vim.api.nvim_set_hl(0, "FloatBorder", overrides.FloatBorder) end

  -- Call the input prompt
  vim.ui.input({ prompt = prompt }, function(input)
    vim.api.nvim_set_hl(0, "NormalFloat", original_float)
    vim.api.nvim_set_hl(0, "FloatBorder", original_border)

    callback(input)
  end)
end

return M
