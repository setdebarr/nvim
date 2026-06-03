---@module 'lazy'
---@type LazySpec
return {
    "nvim-treesitter/nvim-treesitter-context",

    event = { "BufReadPost", "BufNewFile" },

    config = function()
        require("sean.plugins.treesitter-context")
    end,
}
