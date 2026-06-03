---@type NordicOptions
---@diagnostic disable-next-line: missing-fields
local config = {
    bright_border = true,
    swap_backgrounds = true,
    telescope = {
        style = "classic",
    },
    visual = {
        theme = "light",
    },
}

require("nordic").load(config)
