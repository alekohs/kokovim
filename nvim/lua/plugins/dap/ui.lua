local go = require("plugins.dap.go")
local python = require("plugins.dap.python")

return kokovim.get_plugin_by_repo("rcarriga/nvim-dap-ui", {
  cond = not vim.g.vscode,
  opts = {},
  keys = {
    { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
    { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" } },
  },
  config = function(_, opts)
    local dap = require("dap")
    local dapui = require("dapui")
    dapui.setup(opts)

    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open({}) end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close({}) end
    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close({}) end
  end,
  dependencies = {
    kokovim.get_plugin_by_repo("nvim-neotest/nvim-nio"),
    kokovim.get_plugin_by_repo("theHamsta/nvim-dap-virtual-text", {
      opts = {},
    }),
    go,
    python,
  },
})
