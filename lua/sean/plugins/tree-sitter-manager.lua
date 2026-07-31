local dependencies = { "tree-sitter", "git", "cc" }
local missing_dependencies = vim.tbl_filter(function(executable)
    return vim.fn.executable(executable) == 0
end, dependencies)
local can_install = #missing_dependencies == 0

if not can_install then
    vim.notify_once(
        "Tree-sitter parser installation disabled; missing executables: "
            .. table.concat(missing_dependencies, ", "),
        vim.log.levels.ERROR
    )
end

---@type tree_sitter_manager.Config
local config = {
    auto_install = can_install,
    ensure_installed = can_install and {
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
    } or {},
}

require("tree-sitter-manager").setup(config)
