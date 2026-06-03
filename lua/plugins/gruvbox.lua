---@module 'lazy'
---@type LazySpec
return {
    "ellisonleao/gruvbox.nvim",

    enabled = false,

    lazy = false,

    priority = 1000,

    config = function()
        require("sean.plugins.gruvbox")
    end,
}
