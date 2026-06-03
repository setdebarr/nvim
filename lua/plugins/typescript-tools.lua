---@module 'lazy'
---@type LazySpec
return {
    "pmizio/typescript-tools.nvim",

    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },

    config = function()
        require("sean.plugins.typescript-tools")
    end,
}
