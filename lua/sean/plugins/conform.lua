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

        python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },

        rust = { "rustfmt" },

        c = { "clang-format" },
        cpp = { "clang-format" },

        lua = { "stylua" },

        go = { "gofmt" },

        sh = { "shfmt" },
        bash = { "shfmt" },

        vhdl = { "vsg" },
    },
    formatters = {
        ["clang-format"] = {
            prepend_args = { "-style=file", "-fallback-style=LLVM" },
        },
    },
}

require("conform").setup(config)
require("sean.keymap").conform()
