---@module "conform"
---@type conform.setupOpts
local config = {
    formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },

        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },

        python = { "isort", "black" },

        rust = { "rustfmt" },

        c = { "clang-format" },
        cpp = { "clang-format" },

        lua = { "stylua" },

        go = { "gofmt" },

        sh = { "shfmt" },
        bash = { "shfmt" },
    },
    formatters = {
        ["clang-format"] = {
            prepend_args = { "-style=file", "-fallback-style=LLVM" },
        },
    },
}

require("conform").setup(config)

local map = require("sean.utils").map

map({ "n", "v" }, "<leader>ff", function()
    require("conform").format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
    })
end, { desc = "Format file or range (in visual mode)" })
