local action_state = require("telescope.actions.state")
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

local live_grep_toggles = setmetatable({}, { __mode = "k" })

local function attach_live_grep_mappings(prompt_bufnr, map)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local function map_toggle(toggle_mode)
        local mappings = require("sean.keymap").telescope_live_grep_mappings(toggle_mode)
        for mode, bindings in pairs(mappings) do
            for lhs, rhs in pairs(bindings) do
                map(mode, lhs, rhs)
            end
        end
    end
    -- Resume rebuilds the picker but retains its attach_mappings function.
    local existing_toggle = live_grep_toggles[picker.attach_mappings]
    if existing_toggle then
        map_toggle(existing_toggle)
        return true
    end

    local original_finder = picker.finder
    local title = picker.prompt_title
    local regex = false

    -- Keep Telescope's command and scope handling; escape only the search pattern.
    local finder = setmetatable({
        close = function()
            original_finder:close()
        end,
    }, {
        __call = function(_, prompt, process_result, process_complete)
            if not regex and prompt then
                prompt = prompt:gsub("[\\.^$|?*+()%[%]{}]", "\\%0")
            end
            return original_finder(prompt, process_result, process_complete)
        end,
    })
    picker.finder = finder

    local function update_title(current_picker)
        current_picker.prompt_title = title .. (regex and " (Regex)" or " (Plain)")
        current_picker.prompt_border:change_title(current_picker.prompt_title)
    end
    update_title(picker)

    local function toggle_mode(bufnr)
        local current_picker = action_state.get_current_picker(bufnr)
        -- Fuzzy refinement replaces the finder with a frozen result set.
        if current_picker.finder ~= finder then
            return
        end
        regex = not regex
        update_title(current_picker)
        current_picker:refresh(finder, { reset_prompt = false })
    end

    live_grep_toggles[picker.attach_mappings] = toggle_mode
    map_toggle(toggle_mode)
    return true
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
        live_grep = {
            attach_mappings = attach_live_grep_mappings,
        },
    },
}

require("telescope").setup(telescope_config)

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")
pcall(require("telescope").load_extension, "fidget")

require("sean.keymap").telescope()
