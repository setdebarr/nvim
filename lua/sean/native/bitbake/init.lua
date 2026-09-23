local scanner = require("sean.native.bitbake.scanner")

local M = {}

local augroup = vim.api.nvim_create_augroup("SeanBitbake", { clear = true })

---@class SeanBitbakeState
---@field root string|nil
---@field buildDir string|nil
---@field layers string[]
---@field result table|nil
---@field scanning boolean
local state = {
    root = nil,
    buildDir = nil,
    layers = {},
    result = nil,
    scanning = false,
}

local SERVER_NAME = "language-server-bitbake"
local SCAN_COMPLETE = "bitbake/ScanComplete"

---Push the current scan result to every attached bitbake server.
local function push_scan()
    if not state.result then
        return
    end
    for _, client in ipairs(vim.lsp.get_clients({ name = SERVER_NAME })) do
        client:notify(
            SCAN_COMPLETE --[[@as vim.lsp.protocol.Method.ClientToServer.Notification]],
            state.result
        )
    end
end

---Set workspace settings the server needs (pathToBitbakeFolder).
local function push_settings()
    local buildDir = state.buildDir
    if not buildDir then
        return
    end
    -- bitbake lives at <build>/layers/bitbake in kas layouts
    local bitbakeFolder = buildDir .. "/layers/bitbake"
    local payload = {
        settings = {
            bitbake = {
                pathToBitbakeFolder = bitbakeFolder,
            },
        },
    }
    for _, client in ipairs(vim.lsp.get_clients({ name = SERVER_NAME })) do
        client:notify("workspace/didChangeConfiguration", payload)
    end
end

---Kick off an async scan of the project rooted at `start`.
---@param start string
function M.scan(start)
    if state.scanning then
        return
    end

    local root, buildDir = scanner.detect(start)
    if not buildDir then
        vim.notify("No bblayers.conf found from " .. start, vim.log.levels.WARN)
        return
    end

    state.root = root
    state.buildDir = buildDir
    state.layers = scanner.parse_layers(buildDir)
    state.result = nil
    state.scanning = true

    scanner.scan(buildDir, state.layers, function(result)
        state.result = result
        state.scanning = false
        push_settings()
        push_scan()
    end)
end

---Rescan the current buffer's project.
function M.rescan()
    local bufnr = vim.api.nvim_get_current_buf()
    local path = vim.api.nvim_buf_get_name(bufnr)
    if path == "" then
        return
    end
    M.scan(vim.fs.dirname(path))
end

---Wire up FileType + LspAttach autocmds.
function M.setup()
    vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        pattern = "bitbake",
        callback = function(ev)
            local path = vim.api.nvim_buf_get_name(ev.buf)
            if path ~= "" then
                M.scan(vim.fs.dirname(path))
            end
        end,
    })

    vim.api.nvim_create_autocmd("LspAttach", {
        group = augroup,
        callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            if client and client.name == SERVER_NAME then
                push_settings()
                push_scan()
            end
        end,
    })
end

return M
