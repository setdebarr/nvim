local M = {}

function M.setup()
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),

        callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            if not client then
                return
            end

            require("sean.keymap").lsp(client, ev.buf)

            if client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
                vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
            end
        end,
    })
end

return M
