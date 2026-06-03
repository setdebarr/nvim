---@module 'lazy'
---@type LazySpec
return {
    "windwp/nvim-autopairs",

    event = "InsertEnter",

    config = function()
        require("sean.plugins.autopairs")
    end,
}
