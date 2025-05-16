local utils = require("utils")
local picker = require("kokovim.picker")

return {
  utils.getPlugin("harpoon2", "ThePrimeagen/harpoon", {
    event = "VeryLazy",
    branch = "harpoon2",
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon - Add" })
      vim.keymap.set("n", "<leader>hl", function() picker.harpoon_fzf(harpoon:list()) end, { desc = "Harpoon - List" })

      vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Harpoon - Buf 1" })
      vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Harpoon - Buf 2" })
      vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Harpoon - Buf 3" })
      vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Harpoon - Buf 4" })

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end, { desc = "Harpoon - Previous" })
      vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end, { desc = "Harpoon - Next" })


    end,
  }),
}
