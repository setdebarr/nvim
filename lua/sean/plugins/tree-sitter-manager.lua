---@type tree-sitter-manager.Config
local config = {
    auto_install = true,
    ensure_installed = {
        "rust",
        "kotlin",
        "lua",
        "bash",
        "zsh",
        "python",
        "cpp",
        "toml",
        "xml",
        "yaml",
    },
}

require("tree-sitter-manager").setup(config)
