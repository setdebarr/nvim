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

-- Not available via Mason; served by the Godot editor on 127.0.0.1:6005
vim.lsp.enable("gdscript")

-- npm `language-server-bitbake` has no mason-lspconfig mapping, so automatic
-- enable skips it. Enable it manually; config lives in after/lsp/language-server-bitbake.lua.
vim.lsp.enable("language-server-bitbake")
vim.lsp.enable("zls")
