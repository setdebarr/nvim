local M = {}

local function report(source)
    local lint = require("lint")
    local ft = vim.bo[source].filetype
    local running = lint.get_running(source)

    -- Use the same filetype resolution as try_lint, including compound filetypes.
    local configured = lint._resolve_linter_by_ft(ft)

    local lines = {
        "# LintInfo",
        "",
        "Buffer: " .. vim.api.nvim_buf_get_name(source),
        "Filetype: " .. (ft ~= "" and ft or "(none)"),
        "Configured: " .. (#configured > 0 and table.concat(configured, ", ") or "(none)"),
        "Running: " .. (#running > 0 and table.concat(running, ", ") or "(none)"),
        "",
        "Press r to refresh, q to close. Running status is a snapshot.",
        "",
        "## Running linters (all buffers)",
    }

    local any_running = false

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local names = lint.get_running(buf)
        if #names > 0 then
            table.sort(names)
            lines[#lines + 1] = string.format(
                "- [%d] %s: %s",
                buf,
                vim.api.nvim_buf_get_name(buf),
                table.concat(names, ", ")
            )
            any_running = true
        end
    end

    if not any_running then
        lines[#lines + 1] = "(none)"
    end

    vim.list_extend(lines, {
        "",
        "## Current buffer configuration",
        "",
        "Linter factories are resolved for this buffer; function fields are shown unevaluated.",
    })

    local names = vim.list.unique(vim.list_extend(vim.deepcopy(configured), running))
    table.sort(names)

    for _, name in ipairs(names) do
        local ok, config = pcall(function()
            local definition = assert(lint.linters[name], "Linter definition not found: " .. name)

            if type(definition) == "function" then
                definition = definition()
            end

            local resolved = vim.deepcopy(definition)
            resolved.cwd = resolved.cwd or vim.fn.getcwd()

            return resolved
        end)

        vim.list_extend(lines, { "", "### " .. name, "", "```lua" })
        vim.list_extend(lines, vim.split(ok and vim.inspect(config) or tostring(config), "\n"))

        lines[#lines + 1] = "```"
    end

    if #names == 0 then
        lines[#lines + 1] = "(none)"
    end

    return lines
end

function M.open()
    local source = vim.api.nvim_get_current_buf()
    local buf = vim.api.nvim_create_buf(false, true)

    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false

    local function refresh()
        if not vim.api.nvim_buf_is_valid(source) then
            vim.notify("The source buffer has been deleted", vim.log.levels.WARN)
            return
        end

        local lines = vim.api.nvim_buf_call(source, function()
            return report(source)
        end)

        vim.bo[buf].modifiable = true
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.bo[buf].modifiable = false
    end

    refresh()

    local available_height = math.max(1, vim.o.lines - vim.o.cmdheight - 2)
    local width = math.max(1, math.min(120, math.floor(vim.o.columns * 0.85)))
    local height = math.max(1, math.floor(available_height * 0.8))

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        col = math.floor((vim.o.columns - width) / 2),
        row = math.floor((available_height - height) / 2),
        style = "minimal",
        border = "rounded",
        title = " LintInfo ",
        title_pos = "center",
    })

    vim.wo[win].wrap = true
    vim.wo[win].linebreak = true
    vim.bo[buf].filetype = "markdown"

    -- Keep window-navigation keys inside the floating pane.
    for _, key in ipairs({ "<C-h>", "<C-j>", "<C-k>", "<C-l>" }) do
        vim.keymap.set("n", key, "<Nop>", { buffer = buf, desc = "Disable pane switching" })
    end

    vim.keymap.set("n", "r", refresh, { buffer = buf, desc = "Refresh linter info" })
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, desc = "Close linter info" })
end

return M
