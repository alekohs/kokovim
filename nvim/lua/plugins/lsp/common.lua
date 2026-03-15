-- Shared capabilities (for blink-cmp etc.)
local M = {}
M.capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))
  capabilities = vim.tbl_deep_extend("force", capabilities, {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
  })

  return capabilities
end

-- Shared `on_attach` if you want keymaps, etc.
M.on_attach = function(client, bufnr)
  local navic = require("nvim-navic")

  -- Stop if buftype is empty
  local bt = vim.bo[bufnr].buftype
  if bt ~= "" and client.name ~= "html" then
    client.stop()
    return
  end

  if client.server_capabilities.documentSymbolProvider then
    local dominated = client.name == "html" and vim.bo[bufnr].filetype == "razor"
    if not dominated then
      navic.attach(client, bufnr)
    end
  end

end

return M
