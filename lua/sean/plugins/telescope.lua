local actions = require("telescope.actions")
local layout_strategies = require("telescope.pickers.layout_strategies")

layout_strategies.adaptive = function(picker, max_columns, max_lines, layout_config)
    layout_config = layout_config or {}
    local w = layout_config.width or 0.8
    local popup_width = type(w) == "number" and w < 1 and math.floor(max_columns * w)
        or math.min(max_columns, w)
    if popup_width < 130 then
        return layout_strategies.vertical(picker, max_columns, max_lines, layout_config)
    end
    return layout_strategies.horizontal(picker, max_columns, max_lines, layout_config)
end

local telescope_config = {
    defaults = {
        layout_strategy = "adaptive",
        layout_config = {
            width = 0.9,
            vertical = {
                preview_cutoff = 0,
                preview_height = 0.5,
            },
        },
        file_ignore_patterns = {
            "^%.git/",
            "/%.git/",
            "^node_modules/",
            "/node_modules/",
        },
        get_selection_window = function()
            local wins = vim.api.nvim_list_wins()
            table.insert(wins, 1, vim.api.nvim_get_current_win())

            for _, win in ipairs(wins) do
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.bo[buf].buftype == "" then
                    return win
                end
            end

            return 0
        end,
    },
    extensions = {
        ["ui-select"] = require("telescope.themes").get_dropdown(),
    },
    pickers = {
        buffers = {
            initial_mode = "normal",
            mappings = require("sean.keymap").telescope_picker_mappings(actions),
        },
        find_files = {
            hidden = true,
        },
    },
}

require("telescope").setup(telescope_config)

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")
pcall(require("telescope").load_extension, "fidget")

require("sean.keymap").telescope()
