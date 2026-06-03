vim.keymap.set("n", "<leader>e", "<Cmd>NvimTreeToggle<CR>")

---@type nvim_tree.config
local config = {
    hijack_cursor = true,
    sync_root_with_cwd = true,
    disable_netrw = true,
    update_focused_file = { enable = true },
    diagnostics = { enable = true },
    modified = { enable = true },
    renderer = {
        highlight_git = "all",
        indent_markers = { enable = true },
    },
    view = {
        number = true,
        relativenumber = true,
        width = {
            max = 80,
        },
    },
    filters = {
        git_ignored = false,
    },
}

require("nvim-tree").setup(config)
