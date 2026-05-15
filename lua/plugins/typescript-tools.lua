---@module 'lazy'
---@type LazySpec
return {
    "pmizio/typescript-tools.nvim",

    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },

    config = function()
        require("typescript-tools").setup({})

        local map = require("utils").map

        map("n", "<A-o>", "<cmd>TSToolsOrganizeImports<CR>", { desc = "Organize Imports" })
    end,
}
