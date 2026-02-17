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
  local navbuddy = require("nvim-navbuddy")

  -- Stop if buftype is empty
  local bt = vim.api.nvim_buf_get_option(bufnr, "buftype")
  if bt ~= "" and client.name ~= "html" then
    client.stop()
    return
  end

  if client.server_capabilities.documentSymbolProvider then
    local dominated = client.name == "html" and vim.bo[bufnr].filetype == "razor"
    if not dominated then
      vim.notify("Attach navic to buffer", vim.log.levels.DEBUG)
      navic.attach(client, bufnr)
      navbuddy.attach(client, bufnr)
    end
  end

  vim.keymap.set("n", "<leader>ck", function() require("nvim-navbuddy").open() end, { desc = "Lsp Navigation", buffer = bufnr })
  vim.keymap.set("n", "<leader>cP", function()
    for _, c1 in ipairs(vim.lsp.get_active_clients()) do
      print("Client:", c1.name)
      for _, b1 in ipairs(client.buffers) do
        print(" - Buffer:", b1, "File:", vim.api.nvim_buf_get_name(b1))
      end
    end
  end, { desc = "Lsp Navigation", buffer = bufnr })
end

return M
