-- Tabs
vim.keymap.set("n", "<leader><tab>o", "<CMD>tabonly<CR>", { desc = "Close Other tabs" })
vim.keymap.set("n", "<leader><tab>l", "<CMD>tablast<CR>", { desc = "Last tab" })
vim.keymap.set("n", "<leader><tab>f", "<CMD>tabfirst<CR>", { desc = "First tab" })
vim.keymap.set("n", "<leader><tab><tab>", "<CMD>tabnew<CR>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab>]", "<CMD>tabnext<CR>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>d", "<CMD>tabclose<CR>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader><tab>[", "<CMD>tabprevious<CR>", { desc = "Previous Tab" })

-- Windows
vim.keymap.set("n", "<leader>w-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>w|", "<C-W>v", { desc = "Split Window Right", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

