local utils = require("sean.utils")

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

if utils.theme == "nordic" then
    require("nordic").load(config)
end
