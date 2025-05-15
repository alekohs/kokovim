local utils = require("utils")
-- local builtin = require('telescope.builtin')

-- vim.keymap.set('n', '<leader><space>', builtin.find_files, { desc = 'Telescope find files' })
-- vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'Telescope live grep' })
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

return utils.getPlugin("telescope.nvim", "nvim-telescope/telescope.nvim", {
  cmd = "Telescope",
  dependencies = { utils.getPlugin("plenary.nvim", "nvim-lua/plenary.nvim") }
})
