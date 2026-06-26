local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

---@module 'lazy'
---@type LazySpec[]
local spec = {
    -- Colorschemes
    {
        "AlexvZyl/nordic.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("sean.plugins.nordic")
        end,
    },
    {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("sean.plugins.gruvbox")
        end,
    },

    -- LSP
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        dependencies = {},
    },
    {
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
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("sean.plugins.typescript-tools")
        end,
    },

    -- Treesitter
    {
        "romus204/tree-sitter-manager.nvim",
        dependencies = {},
        config = function()
            require("sean.plugins.tree-sitter-manager")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("sean.plugins.treesitter-context")
        end,
    },

    -- Finder
    {
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
            "nvim-telescope/telescope-ui-select.nvim",
            { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
            "j-hui/fidget.nvim",
        },
        config = function()
            require("sean.plugins.telescope")
        end,
    },

    -- File tree
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("sean.plugins.nvim-tree")
        end,
    },

    -- UI
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("sean.plugins.lualine")
        end,
    },
    {
        "j-hui/fidget.nvim",
        config = function()
            require("sean.plugins.fidget")
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("sean.plugins.indent-blankline")
        end,
    },
    {
        "sphamba/smear-cursor.nvim",
        config = function()
            require("sean.plugins.smear-cursor")
        end,
    },

    -- Git
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("sean.plugins.gitsigns")
        end,
    },
    {
        "tpope/vim-fugitive",
        config = function() end,
    },

    -- Editing
    {
        "stevearc/conform.nvim",
        event = { "BufReadPre", "BufNewFile" },
        cmd = { "ConformInfo" },
        config = function()
            require("sean.plugins.conform")
        end,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("sean.plugins.autopairs")
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        config = function()
            require("sean.plugins.nvim-ts-autotag")
        end,
    },
    {
        "fei6409/log-highlight.nvim",
        config = function()
            require("sean.plugins.log-highlight")
        end,
    },
}

require("lazy").setup({
    spec = spec,
    checker = {
        notify = false,
        enabled = true,
    },
})
