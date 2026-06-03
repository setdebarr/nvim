---@module 'lazy'
---@type LazySpec
return {
    "stevearc/conform.nvim",

    event = { "BufReadPre", "BufNewFile" },

    cmd = { "ConformInfo" },

    keys = {
        {
            "<leader>ff",
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

    config = function()
        require("sean.plugins.conform")
    end,
}
