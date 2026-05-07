---@module 'lazy'
---@type LazySpec
return {
    "stevearc/conform.nvim",

    event = { "BufReadPre", "BufNewFile" },

    cmd = { "ConformInfo" },

    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        formatters_by_ft = {
            javascript = { "prettier" },
            typescript = { "prettier" },
            javascriptreact = { "prettier" },
            typescriptreact = { "prettier" },

            svelte = { "prettier" },
            css = { "prettier" },
            html = { "prettier" },
            json = { "prettier" },
            yaml = { "prettier" },
            markdown = { "prettier" },

            python = { "isort", "black" },

            rust = { "rustfmt", lsp_format = "fallback" },

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
    },

    keys = {
        {
            "<C-i>",
            function()
                require("conform").format({
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 1000,
                })
            end,
            mode = { "n", "v" },
            desc = "Format file or range (in visual mode)",
        },
    },
}
