local lint = require("lint")

lint.linters_by_ft = {
    bitbake = { "oelint-adv" },
}

local function try_lint()
    if vim.fn.filereadable(vim.api.nvim_buf_get_name(0)) == 1 then
        lint.try_lint()
    end
end

vim.api.nvim_create_autocmd({ "FileType", "BufWritePost" }, {
    group = vim.api.nvim_create_augroup("SeanLint", { clear = true }),
    callback = try_lint,
})

try_lint()
