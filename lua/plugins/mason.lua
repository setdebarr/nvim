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
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "clangd",
                "pyright",
                "gopls",
                "rust_analyzer",
            },
        })
    end,
}
