return kokovim.get_plugin_by_repo("leoluz/nvim-dap-go", {
  cond = not vim.g.vscode,
  config = true,
  keys = {
    {
      "<leader>dt",
      function() require("dap-go").debug_test() end,
      desc = "Debug test",
    },
  },
})
