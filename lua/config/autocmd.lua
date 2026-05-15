local map = require("utils").map

local function clangd_keymaps(client, bufnr)
    if client.name ~= "clangd" then
        return
    end

    map("n", "<F4>", "<cmd>LspClangdSwitchSourceHeader<cr>", {
        buffer = bufnr,
        desc = "Switch Source/Header",
    })
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),

    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then
            return
        end

        clangd_keymaps(client, ev.buf)

        local opts = { buffer = ev.buf }

        opts.desc = "Go to declaration"
        map("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "See available code actions"
        map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        map("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Show line diagnostics"
        map("n", "<leader>ld", vim.diagnostic.open_float, opts)

        opts.desc = "Go to previous diagnostic"
        map("n", "[d", function()
            vim.diagnostic.jump({
                count = -1,
                on_jump = function()
                    vim.diagnostic.open_float()
                end,
            })
        end, opts)

        opts.desc = "Go to next diagnostic"
        map("n", "]d", function()
            vim.diagnostic.jump({
                count = 1,
                on_jump = function()
                    vim.diagnostic.open_float()
                end,
            })
        end, opts)

        opts.desc = "Hover documentation"
        map("n", "K", function()
            vim.lsp.buf.hover({ border = "single" })
        end, opts)

        opts.desc = "Restart LSP"
        map("n", "<leader>rs", ":lsp restart<CR>", opts)

        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
            vim.opt.completeopt = { "menu", "menuone", "noinsert", "fuzzy", "popup" }
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
            map("i", "<C-Space>", function()
                vim.lsp.completion.get()
            end)
        end
    end,
})
