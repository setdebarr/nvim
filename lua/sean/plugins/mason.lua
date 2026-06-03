require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "clangd",
        "pyright",
        "gopls",
        "rust_analyzer",
    },
})
