---@module "mason-lspconfig"
---@type MasonLspconfigSettings
local config = {
    ensure_installed = {
        "lua_ls",
        "clangd",
        "pyright",
        "gopls",
        "rust_analyzer",
    },
    automatic_enable = {
        exclude = {
            "roslyn_ls",
        },
    },
}

require("mason-lspconfig").setup(config)
