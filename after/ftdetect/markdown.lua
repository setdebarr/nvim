vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.MD",
    callback = function()
        vim.bo.filetype = "markdown"
    end,
})
