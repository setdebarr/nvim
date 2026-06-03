---@module 'lazy'
---@type LazySpec
return {
    "nvim-lualine/lualine.nvim",

    dependencies = { "nvim-tree/nvim-web-devicons" },

    config = function()
        require("sean.plugins.lualine")
    end,
}
