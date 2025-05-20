local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local group = augroup("KokovimAi", { clear = true })

local function get_all_buffers_content()
  local result = ""
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "buflisted") then
      local name = vim.api.nvim_buf_get_name(buf)
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      if name ~= "" then
        result = result .. ("-- FILE: " .. name .. "\n" .. table.concat(lines, "\n") .. "\n\n")
      end
    end
  end
  return result
end
