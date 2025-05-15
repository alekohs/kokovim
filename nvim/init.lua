local utils = require("utils")
print("Loaded app '" .. utils.getAppName() .. "' with nix: " .. tostring(utils.isNixApp()))
require("config.lazy")
