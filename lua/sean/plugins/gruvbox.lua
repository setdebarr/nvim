---@type GruvboxConfig
local config = {
    bold = false,
    contrast = "hard",
    terminal_colors = false,
}

require("gruvbox").setup(config)
require("gruvbox").load()
