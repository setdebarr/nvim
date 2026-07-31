---@module "trouble"
---@type trouble.Config
local config = {
    win = {
        type = "split",
    },
}

require("trouble").setup(config)
require("sean.keymap").trouble()
