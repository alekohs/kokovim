local utils = require("utils")
print("Loaded app '" .. utils.appName .. "' with nix: " .. tostring(utils.isNixApp()))
require("config.lazy")
