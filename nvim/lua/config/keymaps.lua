-- Key mappings for system clipboard
local mappings = {
  { mode = "n", keys = { "y", "Y", "p", "P" } },
  { mode = "v", keys = { "y", "p" } },
}
local descriptions = {
  ["y"] = "Yank to system clipboard",
  ["Y"] = "Yank line to system clipboard",
  ["p"] = "Paste from system clipboard",
  ["P"] = "Paste before from system clipboard",
}

for _, map in ipairs(mappings) do
  for _, key in ipairs(map.keys) do
    local rhs = '"+' .. key
    vim.keymap.set(map.mode, "<leader>" .. key, rhs, { noremap = true, silent = true, desc = rhs .. " " .. descriptions[key] })
  end
end

-- Movement
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true, desc = "Half-page down with center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true, desc = "Half-page up with center" })

-- Tabs
vim.keymap.set("n", "<leader><tab>o", "<CMD>tabonly<CR>", { desc = "Close Other tabs" })
vim.keymap.set("n", "<leader><tab>l", "<CMD>tablast<CR>", { desc = "Last tab" })
vim.keymap.set("n", "<leader><tab>f", "<CMD>tabfirst<CR>", { desc = "First tab" })
vim.keymap.set("n", "<leader><tab><tab>", "<CMD>tabnew<CR>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab>d", "<CMD>tabclose<CR>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader><tab>]", "<CMD>tabnext<CR>", { desc = "Next Tab" })
vim.keymap.set("n", "<tab>]", "<CMD>tabnext<CR>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>[", "<CMD>tabprevious<CR>", { desc = "Previous Tab" })
vim.keymap.set("n", "<tab>[", "<CMD>tabprevious<CR>", { desc = "Previous Tab" })

-- Windows
vim.keymap.set("n", "<leader>w-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>w|", "<C-W>v", { desc = "Split Window Right", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- Extra keymaps
vim.keymap.set("n", "<leader>se", ":Endpoint <CR>", { desc = "Search Endpoints" })
