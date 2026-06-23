local M = {}

local state = {
    buf = nil,
    win = nil,
}

local border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

local function open()
    local screen_w = vim.o.columns
    local screen_h = vim.o.lines - vim.o.cmdheight - 1

    local width = math.floor(screen_w * 0.95)
    local height = math.floor(screen_h * 0.95)

    local col = math.floor((screen_w - width) / 2)
    local row = math.floor((screen_h - height) / 2)

    local buf = vim.api.nvim_create_buf(false, true)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal",
        border = border_chars,
    })

    state.buf = buf
    state.win = win

    vim.fn.jobstart("lazygit", {
        term = true,
        on_exit = function()
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
            end

            if vim.api.nvim_buf_is_valid(buf) then
                vim.api.nvim_buf_delete(buf, { force = true })
            end

            state.buf = nil
            state.win = nil
        end,
    })

    vim.cmd("startinsert")
end

function M.toggle()
    if state.win and vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_win_close(state.win, true)
        state.win = nil
    else
        open()
    end
end

return M
