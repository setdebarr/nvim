local M = {}

---@alias KeymapMode
---| "n"  # Normal
---| "i"  # Insert
---| "v"  # Visual and Select
---| "x"  # Visual
---| "s"  # Select
---| "o"  # Operator-pending
---| "t"  # Terminal
---| "c"  # Command-line

---@param mode KeymapMode|KeymapMode[]
---@param lhs string
---@param rhs string|function
---@param opts? vim.keymap.set.Opts
function M.map(mode, lhs, rhs, opts)
    local options = vim.tbl_extend("force", {
        remap = false,
        silent = true,
    }, opts or {})

    vim.keymap.set(mode, lhs, rhs, options)
end

function M.get_root()
    local root

    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        local client_root = client.config.root_dir
        if type(client_root) == "string" and (not root or #client_root > #root) then
            root = client_root
        end
    end

    return root or M.get_git_root()
end

function M.get_git_root()
    ---@type integer|string
    local source = 0

    if vim.bo.filetype == "NvimTree" then
        local ok, api = pcall(require, "nvim-tree.api")
        if ok then
            local node = api.tree.get_node_under_cursor()
            if node then
                source = node.absolute_path
            end
        end
    end

    return vim.fs.root(source, ".git") or vim.fn.getcwd()
end

function M.get_visual_selection()
    return table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos(".")), "\n")
end

---@alias MyTheme
---| "caelus"
---| "nordic"
---| "gruvbox"

---@type MyTheme
M.theme = "caelus"

return M
