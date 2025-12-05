local augroup = vim.api.nvim_create_augroup
local aucmd = vim.api.nvim_create_autocmd
local group = augroup("KokovimLsp", { clear = true })

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

    if client and (client.name == "roslyn" or client.name == "roslyn-ls") then
      local opts = { buffer = args.buf, desc = "", noremap = true, silent = true }

      vim.keymap.set("n", "<leader>cxd", function()
        local cwd = vim.fn.getcwd()
        local cmd = string.format("find %s -type d \\( -name bin -o -name obj \\) -exec rm -rf {} +", cwd)
        vim.fn.system(cmd)
        print("Deleted all bin/ and obj/ folders under " .. cwd)
      end, { desc = "Dotnet - clean bin/ obj/" })
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
