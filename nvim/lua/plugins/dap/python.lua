return kokovim.get_plugin_by_repo("mfussenegger/nvim-dap-python", {
  lazy = true,
  config = function()
    require("dap-python").setup()
  end,
})
