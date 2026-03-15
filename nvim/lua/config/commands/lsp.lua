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
        local cmd = string.format("find %s -type d \\( -name bin -o -name obj \\) -exec rm -rf {} +", vim.fn.shellescape(cwd))
        vim.fn.system(cmd)
        print("Deleted all bin/ and obj/ folders under " .. cwd)
      end, { desc = "Dotnet - clean bin/ obj/" })

      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
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
      if vim.api.nvim_buf_is_valid(bufnr) then vim.lsp.inlay_hint.enable(true, { bufnr = bufnr }) end
    end, 100)
  end,
})
