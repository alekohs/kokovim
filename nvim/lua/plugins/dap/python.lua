return kokovim.get_plugin_by_repo("mfussenegger/nvim-dap-python", {
  cond = not vim.g.vscode,
  lazy = true,
  config = function()
    require("dap-python").setup()
  end,
})
