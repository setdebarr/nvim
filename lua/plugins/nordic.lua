---@module 'lazy'
---@type LazySpec
return {
    "AlexvZyl/nordic.nvim",

    lazy = false,

    priority = 1000,

    config = function()
        require("nordic").load({
            bright_border = true,
            swap_backgrounds = true,
            telescope = {
                style = "classic",
            },
            visual = {
                theme = "light",
            },
        })
    end,
}
