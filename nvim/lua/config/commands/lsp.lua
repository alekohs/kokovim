local augroup = vim.api.nvim_create_augroup
local aucmd = vim.api.nvim_create_autocmd
local group = augroup("KokovimLsp", { clear = true })

local function is_roslyn_client(client)
  return client and (client.name == "roslyn" or client.name == "roslyn-ls" or client.name == "roslyn_ls")
end

local function set_inlay_hints(enabled)
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buftype == "" and vim.bo[bufnr].filetype ~= "vue" then
      pcall(vim.lsp.inlay_hint.enable, enabled, { bufnr = bufnr })
    end
  end
end

if vim.g.kokovim_inlay_focus_off == nil then
  vim.g.kokovim_inlay_focus_off = false
end

if not vim.g.kokovim_inlay_focus_toggle_mapped then
  vim.keymap.set("n", "<leader>uh", function()
    vim.g.kokovim_inlay_focus_off = not vim.g.kokovim_inlay_focus_off
    set_inlay_hints(not vim.g.kokovim_inlay_focus_off)
    vim.notify("Inlay hints " .. (vim.g.kokovim_inlay_focus_off and "OFF (focus mode)" or "ON"))
  end, { desc = "Toggle inlay hints (focus mode)" })

  vim.g.kokovim_inlay_focus_toggle_mapped = true
end

aucmd("FileType", {
  group = group,
  pattern = { "cs", "razor" },
  command = "setlocal tabstop=4 shiftwidth=4",
})

aucmd("LspAttach", {
  group = augroup("DotnetLsp", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if is_roslyn_client(client) then
      vim.keymap.set("n", "<leader>cxd", function()
        local cwd = vim.fn.getcwd()
        local cmd = string.format("find %s -type d \\( -name bin -o -name obj \\) -exec rm -rf {} +", vim.fn.shellescape(cwd))
        vim.fn.system(cmd)
        print("Deleted all bin/ and obj/ folders under " .. cwd)
      end, { desc = "Dotnet - clean bin/ obj/" })

      if not vim.b[bufnr].kokovim_roslyn_auto_insert_attached then
        aucmd("InsertCharPre", {
          desc = "Roslyn auto insert",
          buffer = bufnr,
          callback = function()
            local char = vim.v.char
            if char ~= "/" then return end
            if vim.api.nvim_get_current_buf() ~= bufnr then return end

            vim.defer_fn(function()
              local active = vim.lsp.get_clients({ bufnr = bufnr })[1]
              if not active then return end

              local row, col = unpack(vim.api.nvim_win_get_cursor(0))
              local params = {
                _vs_textDocument = { uri = vim.uri_from_bufnr(bufnr) },
                _vs_position = { line = row - 1, character = col },
                _vs_ch = char,
                _vs_options = {
                  tabSize = vim.bo[bufnr].tabstop,
                  insertSpaces = vim.bo[bufnr].expandtab,
                },
              }

              active:request("textDocument/_vs_onAutoInsert", params, function(err, result)
                if err or not result or not result._vs_textEdit then return end

                local text_edit = result._vs_textEdit
                if not text_edit.newText or text_edit.newText == "" then return end

                if vim.snippet and text_edit.newText:find("%$") then
                  vim.snippet.expand(text_edit.newText)
                  return
                end

                if text_edit.range then
                  vim.lsp.util.apply_text_edits({
                    { range = text_edit.range, newText = text_edit.newText },
                  }, bufnr, active.offset_encoding)
                else
                  local cursor = vim.api.nvim_win_get_cursor(0)
                  local line = cursor[1]
                  local col0 = cursor[2]
                  local before = vim.api.nvim_buf_get_text(bufnr, line - 1, 0, line - 1, col0, {})[1] or ""
                  local slash_idx = before:find("/%s*$")
                  if slash_idx then
                    vim.api.nvim_buf_set_text(bufnr, line - 1, slash_idx - 1, line - 1, col0, { text_edit.newText })
                  end
                end
              end, bufnr)
            end, 1)
          end,
        })

        vim.b[bufnr].kokovim_roslyn_auto_insert_attached = true
      end

      vim.lsp.inlay_hint.enable(not vim.g.kokovim_inlay_focus_off, { bufnr = bufnr })
    end
  end,
})

-- Toggle inlay hints off in insert mode for C#/Razor
local inlay_hint_group = augroup("RoslynInlayHintToggle", { clear = true })

aucmd("InsertEnter", {
  group = inlay_hint_group,
  pattern = { "*.razor" },
  callback = function(args) vim.lsp.inlay_hint.enable(false, { bufnr = args.buf }) end,
})

aucmd("InsertLeave", {
  group = inlay_hint_group,
  pattern = { "*.razor" },
  callback = function(args)
    local bufnr = args.buf
    vim.defer_fn(function()
      if vim.api.nvim_buf_is_valid(bufnr) then
        vim.lsp.inlay_hint.enable(not vim.g.kokovim_inlay_focus_off, { bufnr = bufnr })
      end
    end, 100)
  end,
})
