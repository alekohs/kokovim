local M = {}

M.capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))
  return capabilities
end

M.on_attach = function(client, bufnr)
if client.server_capabilities.documentSymbolProvider then
    local dominated = client.name == "html" and vim.bo[bufnr].filetype == "razor"
    if not dominated then
      require("nvim-navic").attach(client, bufnr)
    end
  end

  if client:supports_method("textDocument/inlayHint") and vim.bo[bufnr].filetype ~= "vue" then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end

  -- TODO: remove this when Neovim/Roslyn document_color lifecycle race is fixed upstream.
  if vim.bo[bufnr].filetype == "razor" and (client.name == "roslyn" or client.name == "roslyn-ls") then
    pcall(vim.lsp.document_color.enable, false, { bufnr = bufnr })
  end
end

return M
