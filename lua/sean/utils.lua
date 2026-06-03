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

return M
