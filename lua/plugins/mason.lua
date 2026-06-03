---@module 'lazy'
---@type LazySpec
return {
    "mason-org/mason-lspconfig.nvim",

    dependencies = {
        {
            "mason-org/mason.nvim",
            ---@class MasonSettings
            opts = {
                PATH = "append",
            },
        },
        "neovim/nvim-lspconfig",
    },

    config = function()
        require("sean.plugins.mason")
    end,
}
