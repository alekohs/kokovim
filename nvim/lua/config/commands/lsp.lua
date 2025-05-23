local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local group = augroup("KokovimLsp", { clear = true })

autocmd("FileType", {
  group = group,
  pattern = { "cs", "razor" },
  command = "setlocal tabstop=4 shiftwidth=4",
})

autocmd("InsertCharPre", {
  pattern = "*.cs",
  callback = function()
    local char = vim.v.char

    if char ~= "/" then return end

    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    row, col = row - 1, col + 1
    local bufnr = vim.api.nvim_get_current_buf()
    local uri = vim.uri_from_bufnr(bufnr)

    local params = {
      _vs_textDocument = { uri = uri },
      _vs_position = { line = row, character = col },
      _vs_ch = char,
      _vs_options = { tabSize = 4, insertSpaces = true },
    }

    -- NOTE: we should send textDocument/_vs_onAutoInsert request only after buffer has changed.
    vim.defer_fn(function() vim.lsp.buf_request(bufnr, "textDocument/_vs_onAutoInsert", params) end, 1)
  end,
})
