---@type tree_sitter_manager.Config
local config = {
    auto_install = true,
    ensure_installed = {
        "bash",
        "c",
        "cpp",
        "jsdoc",
        "kotlin",
        "lua",
        "python",
        "rust",
        "toml",
        "xml",
        "yaml",
        "zsh",
    },
}

require("tree-sitter-manager").setup(config)
