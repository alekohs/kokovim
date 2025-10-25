local augroup = vim.api.nvim_create_augroup
local aucmd = vim.api.nvim_create_autocmd
local group = augroup("KokovimLsp", { clear = true })

aucmd("FileType", {
  group = group,
  pattern = { "cs", "razor" },
  command = "setlocal tabstop=4 shiftwidth=4",
})

aucmd("InsertCharPre", {
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

-- Easy dotnet keymaps
aucmd("LspAttach", {
  group = augroup("DotnetLsp", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and (client.name == "roslyn" or client.name == "easy_dotnet") then
      local dotnet = require("easy-dotnet")
      local diagnostics = require("easy-dotnet.actions.diagnostics")
      local opts = { buffer = args.buf, desc = "", noremap = true, silent = true }

      vim.keymap.set("n", "<leader>x", "<cmd>Dotnet<CR>", vim.tbl_extend("force", opts, { desc = "Easy dotnet picker" }))
    end
  end,
})

-- Attach only when Swift LSP is active
aucmd("LspAttach", {
  group = augroup("XcodeBuild", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and (client.name == "sourcekit-lsp" or client.name == "sourcekit") then
      local xcodebuild = require("xcodebuild.integrations.dap")
      local opts = { buffer = args.buf, desc = "", noremap = true, silent = true }

      vim.keymap.set("n", "<leader>dd", xcodebuild.build_and_debug, vim.tbl_extend("force", opts, { desc = "Build & Debug" }))
      vim.keymap.set("n", "<leader>dr", xcodebuild.debug_without_build, vim.tbl_extend("force", opts, { desc = "Debug Without Building" }))
      -- vim.keymap.set("n", "<leader>dt", xcodebuild.debug_tests, vim.tbl_extend("force", opts, { desc = "Debug Tests" }))
      -- vim.keymap.set("n", "<leader>dT", xcodebuild.debug_class_tests, vim.tbl_extend("force", opts, { desc = "Debug Class Tests" }))
      -- vim.keymap.set("n", "<leader>b", xcodebuild.toggle_breakpoint, vim.tbl_extend("force", opts, { desc = "Toggle Breakpoint" }))
      -- vim.keymap.set("n", "<leader>B", xcodebuild.toggle_message_breakpoint, vim.tbl_extend("force", opts, { desc = "Toggle Message Breakpoint" }))
      vim.keymap.set("n", "<leader>dx", xcodebuild.terminate_session, vim.tbl_extend("force", opts, { desc = "Terminate Debugger" }))
    end
  end,
})
