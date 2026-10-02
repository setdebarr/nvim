---@module "flash"
---@type Flash.Config
local config = {}

require("flash").setup(config)
require("sean.keymap").flash()
