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
