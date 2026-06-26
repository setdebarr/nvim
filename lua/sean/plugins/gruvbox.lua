local utils = require("sean.utils")

---@type GruvboxConfig
local config = {
    bold = false,
    contrast = "hard",
    terminal_colors = false,
}

if utils.theme == "gruvbox" then
    require("gruvbox").setup(config)
    require("gruvbox").load()
end
