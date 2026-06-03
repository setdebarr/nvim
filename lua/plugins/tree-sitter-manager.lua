---@module 'lazy'
---@type LazySpec
return {
    "romus204/tree-sitter-manager.nvim",

    dependencies = {},

    config = function()
        require("sean.plugins.tree-sitter-manager")
    end,
}
