local lint = require("lint")

local lint_group = vim.api.nvim_create_augroup("sean-lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
    group = lint_group,
    callback = function()
        lint.try_lint()
    end,
})
