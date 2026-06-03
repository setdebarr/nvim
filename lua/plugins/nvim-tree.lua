---@module 'lazy'
---@type LazySpec
return {
    "nvim-tree/nvim-tree.lua",

    version = "*",

    lazy = false,

    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },

    config = function()
        require("sean.plugins.nvim-tree")
    end,
}
