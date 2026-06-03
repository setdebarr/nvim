local actions = require("telescope.actions")
local layout_strategies = require("telescope.pickers.layout_strategies")

layout_strategies.adaptive = function(picker, max_columns, max_lines, layout_config)
    layout_config = layout_config or {}
    local w = layout_config.width or 0.8
    local popup_width = type(w) == "number" and w < 1 and math.floor(max_columns * w)
        or math.min(max_columns, w)
    -- vim.notify(
    --     string.format(
    --         "[telescope adaptive] max_columns=%d w=%s popup_width=%d -> %s",
    --         max_columns,
    --         tostring(w),
    --         popup_width,
    --         popup_width < 130 and "vertical" or "horizontal"
    --     ),
    --     vim.log.levels.INFO
    -- )
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
            mappings = {
                i = {
                    ["<c-d>"] = actions.delete_buffer,
                },
                n = {
                    ["<c-d>"] = actions.delete_buffer,
                    ["dd"] = actions.delete_buffer,
                },
            },
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

local map = require("utils").map
local builtin = require("telescope.builtin")

local function get_root()
    return vim.uv.cwd()
end

local function get_visual_selection()
    return table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos(".")), "\n")
end

-- notifications
map("n", "<leader>sn", function()
    require("telescope").extensions.fidget.fidget()
end, { desc = "Notifications" })

-- git
map("n", "<leader>gl", builtin.git_commits, { desc = "Git Commits" })
map("n", "<leader>gs", builtin.git_status, { desc = "Git Status" })

map("n", "<leader><leader>", function()
    builtin.buffers({ sort_mru = true, sort_lastused = true })
end, { desc = "Switch Buffer" })

map("n", "<leader>sf", function()
    builtin.find_files({ cwd = get_root() })
end, { desc = "Search Files (Root Dir)" })

map("n", "<leader>fr", builtin.oldfiles, { desc = "Recent" })

-- search
map("n", '<leader>s"', builtin.registers, { desc = "Registers" })
map("n", "<leader>s/", builtin.search_history, { desc = "Search History" })
map("n", "<leader>sa", builtin.autocommands, { desc = "Auto Commands" })
map("n", "<leader>sb", builtin.current_buffer_fuzzy_find, { desc = "Buffer Lines" })
map("n", "<leader>sc", builtin.command_history, { desc = "Command History" })
map("n", "<leader>sC", builtin.commands, { desc = "Commands" })
map("n", "<leader>sd", builtin.diagnostics, { desc = "Diagnostics" })

map("n", "<leader>sD", function()
    builtin.diagnostics({ bufnr = 0 })
end, { desc = "Buffer Diagnostics" })

map("n", "<leader>sg", function()
    builtin.live_grep({ cwd = get_root() })
end, { desc = "Grep (Root Dir)" })

map("n", "<leader>sh", builtin.help_tags, { desc = "Help Pages" })
map("n", "<leader>sH", builtin.highlights, { desc = "Search Highlight Groups" })
map("n", "<leader>sj", builtin.jumplist, { desc = "Jumplist" })
map("n", "<leader>sk", builtin.keymaps, { desc = "Key Maps" })
map("n", "<leader>sl", builtin.loclist, { desc = "Location List" })
map("n", "<leader>sM", builtin.man_pages, { desc = "Man Pages" })
map("n", "<leader>sm", builtin.marks, { desc = "Jump to Mark" })
map("n", "<leader>so", builtin.vim_options, { desc = "Options" })
map("n", "<leader>sR", builtin.resume, { desc = "Resume" })
map("n", "<leader>sq", builtin.quickfix, { desc = "Quickfix List" })

map("n", "<leader>sw", function()
    builtin.grep_string({ cwd = get_root(), word_match = "-w" })
end, { desc = "Word (Root Dir)" })

map("x", "<leader>sw", function()
    builtin.grep_string({ cwd = get_root(), search = get_visual_selection() })
end, { desc = "Selection (Root Dir)" })

map("n", "<leader>uC", function()
    builtin.colorscheme({ enable_preview = true })
end, { desc = "Colorscheme with Preview" })

map("n", "<leader>ss", function()
    builtin.lsp_document_symbols()
end, { desc = "Goto Symbol" })

map("n", "<leader>sS", function()
    builtin.lsp_dynamic_workspace_symbols()
end, { desc = "Goto Symbol (Workspace)" })

map("n", "<leader>/", function()
    local filename = vim.api.nvim_buf_get_name(0)

    if filename == "" then
        builtin.current_buffer_fuzzy_find({
            previewer = false,
        })
        return
    end

    builtin.live_grep({
        winblend = 10,
        previewer = true,
        search_dirs = { filename },
    })
end, { desc = "[/] Search in current buffer" })

map("n", "<leader>//", function()
    builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
end, { desc = "[//] Search in Open Files" })

map("n", "gd", function()
    builtin.lsp_definitions({ reuse_win = true })
end, { desc = "Find Definition" })

map("n", "gr", builtin.lsp_references, { desc = "References", nowait = true })

map("n", "gi", function()
    builtin.lsp_implementations({ reuse_win = true })
end, { desc = "Find Implementation" })

map("n", "gt", function()
    builtin.lsp_type_definitions({ reuse_win = true })
end, { desc = "Find Type Definition" })
