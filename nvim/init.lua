print("Custom config loaded: " .. vim.fn.stdpath("config"))
-- vim.cmd('echo "hello world"')

require("config.lazy")
