local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local progress = vim.defaulttable()

-- Group for general autocmds
local general = augroup("GeneralAutocmds", { clear = true })

-- Close filetypes with 'q'
autocmd("FileType", {
  group = general,
  desc = "Close filetypes with q",
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "oil",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- Highlight on yank
autocmd("TextYankPost", {
  group = general,
  desc = "Highlight on yank",
  pattern = "*",
  callback = function() (vim.hl or vim.hl).on_yank() end,
})

-- Enable autoformat for specific filetypes
autocmd("FileType", {
  group = general,
  desc = "Activate auto format",
  pattern = { "nix", "lua" },
  callback = function() vim.b.autoformat = true end,
})

-- Remove trailing whitespace on save
autocmd("BufWrite", {
  group = general,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-------
---  LSP
------
local lsp = augroup("LspCmds", { clear = true })

-- LSP Progress bar
autocmd("BufWrite", {
  group = lsp,
  desc = "LSP Progress bar",
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value
    if not client or type(value) ~= "table" then return end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ("[%3d%%] %s%s"):format(
            value.kind == "end" and 100 or value.percentage or 100,
            value.title or "",
            value.message and (" **%s**"):format(value.message) or ""
          ),
          done = value.kind == "end",
        }
        break
      end
    end

    local msg = {} ---@type string[]
    progress[client.id] = vim.tbl_filter(function(v) return table.insert(msg, v.msg) or not v.done end, p)

    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(table.concat(msg, "\n"), "info", {
      id = "lsp_progress",
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and " "
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})

-- Set tab width to 4 for C# and Razor files
autocmd("FileType", {
  group = general,
  pattern = { "cs", "razor" },
  command = "setlocal tabstop=4 shiftwidth=4",
})

-- -- Lint on save or insert leave
-- autocmd({ "BufWritePost", "InsertLeave" }, {
--   group = general,
--   desc = "Lint file",
--   pattern = "*",
--   callback = function()
--     require("lint").try_lint()
--   end,
-- })
