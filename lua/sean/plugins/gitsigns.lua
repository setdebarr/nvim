---@module 'gitsigns'
---@type Gitsigns.Config
---@diagnostic disable-next-line: missing-fields
local config = {
    signs = {
        add = { text = "+" }, ---@diagnostic disable-line: missing-fields
        change = { text = "~" }, ---@diagnostic disable-line: missing-fields
        delete = { text = "-" }, ---@diagnostic disable-line: missing-fields
        topdelete = { text = "-" }, ---@diagnostic disable-line: missing-fields
        changedelete = { text = "-" }, ---@diagnostic disable-line: missing-fields
    },
    current_line_blame = true,
    on_attach = function(bufnr)
        require("sean.keymap").gitsigns(bufnr)
    end,
}

require("gitsigns").setup(config)
