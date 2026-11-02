local lint = require("lint")

local eslint = require("lint.linters.eslint")

lint.linters.eslint = function()
    local linter = vim.deepcopy(eslint)
    local cwd = vim.fn.getcwd()
    local path = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
    local prefix = cwd == "/" and cwd or cwd .. "/"

    if not path or (path ~= cwd and not vim.startswith(path, prefix)) then
        return linter
    end

    local cmd = vim.fs.find("node_modules/.bin/eslint", {
        path = path,
        upward = true,
        -- The stop directory is excluded, so include cwd by stopping at its parent.
        stop = cwd ~= "/" and vim.fs.dirname(cwd) or nil,
        type = "file",
    })[1]

    if cmd then
        linter.cmd = cmd
        linter.cwd = vim.fn.fnamemodify(cmd, ":h:h:h")
    end

    return linter
end

local oelint = require("lint.linters.oelint-adv")

lint.linters["oelint-adv"] = function()
    local linter = vim.deepcopy(oelint)
    local filename = vim.api.nvim_buf_get_name(0)
    local root = vim.fs.root(filename, { ".oelint.cfg", ".git" })

    if not root then
        return linter
    end

    linter.cwd = root
    local layers = {}

    for name, kind in vim.fs.dir(root) do
        if kind == "directory" and name:match("^meta%-") then
            layers[#layers + 1] = vim.fs.joinpath(root, name)
        end
    end

    if #layers == 0 and vim.fn.filereadable(vim.fs.joinpath(root, "conf/layer.conf")) == 1 then
        layers = { root }
    end

    local files = {}
    for _, layer in ipairs(layers) do
        for name, kind in vim.fs.dir(layer, { depth = math.huge }) do
            local extension = name:match("%.([^./]+)$")
            if
                kind == "file"
                and (
                    extension == "bb"
                    or extension == "bbappend"
                    or extension == "bbclass"
                    or extension == "inc"
                    or (extension == "conf" and ("/" .. name):match("/conf/"))
                )
            then
                files[#files + 1] = vim.fs.joinpath(layer, name)
            end
        end
    end

    if #files > 0 then
        table.sort(files)
        vim.list_extend(linter.args, files)
        linter.append_fname = false
    end

    return linter
end

lint.linters_by_ft = {
    bitbake = { "oelint-adv" },
    go = { "golangcilint" },
    javascript = { "eslint" },
    typescript = { "eslint" },
    javascriptreact = { "eslint" },
    typescriptreact = { "eslint" },
}

vim.api.nvim_create_user_command("LintInfo", function()
    require("sean.native.lint-info").open()
end, { desc = "Show running linters and current buffer configuration" })

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
