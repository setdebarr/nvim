---@module 'lazy'
---@type LazySpec
return {
    "romus204/tree-sitter-manager.nvim",

    dependencies = {}, -- tree-sitter CLI must be installed system-wide

    config = function()
        require("sean.plugins.tree-sitter-manager")
    end,
}
