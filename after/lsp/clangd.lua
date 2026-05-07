---@type vim.lsp.Config
return {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
    },

    ---@type lspconfig.settings.clangd
    settings = {
        clangd = {},
    },
}
