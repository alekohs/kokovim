local M = {}

M.capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))
  return capabilities
end

M.on_attach = function(client, bufnr)
  local bt = vim.bo[bufnr].buftype
  if bt ~= "" and client.name ~= "html" then
    client.stop()
    return
  end

  if client.server_capabilities.documentSymbolProvider then
    local dominated = client.name == "html" and vim.bo[bufnr].filetype == "razor"
    if not dominated then
      require("nvim-navic").attach(client, bufnr)
    end
  end

  if client:supports_method("textDocument/inlayHint") and vim.bo[bufnr].filetype ~= "vue" then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

return M
