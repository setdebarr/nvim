local dependencies = { "tree-sitter", "curl", "tar", "cc" }
local missing_dependencies = vim.tbl_filter(function(executable)
    return vim.fn.executable(executable) == 0
end, dependencies)
local can_install = #missing_dependencies == 0

if not can_install then
    vim.notify_once(
        "Tree-sitter parser installation disabled; missing executables: "
            .. table.concat(missing_dependencies, ", "),
        vim.log.levels.ERROR
    )
end

local treesitter = require("nvim-treesitter")
treesitter.setup({})

local function start_highlighting(buf)
    if not vim.api.nvim_buf_is_loaded(buf) or vim.bo[buf].buftype ~= "" then
        return false
    end

    local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
    if not lang or #vim.treesitter.query.get_files(lang, "highlights") == 0 then
        return false
    end

    return pcall(vim.treesitter.start, buf, lang)
end

local function install(languages)
    treesitter.install(languages):await(vim.schedule_wrap(function(err)
        if err then
            vim.notify(
                "Tree-sitter parser installation failed: " .. tostring(err),
                vim.log.levels.ERROR
            )
            return
        end

        -- Installation is asynchronous; attach to buffers opened while it ran.
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            start_highlighting(buf)
        end
    end))
end

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
    callback = function(ev)
        if vim.bo[ev.buf].buftype ~= "" or start_highlighting(ev.buf) or not can_install then
            return
        end

        local lang = vim.treesitter.language.get_lang(ev.match)
        local parser = lang and require("nvim-treesitter.parsers")[lang]
        if parser and parser.tier ~= 4 then
            install({ lang })
        end
    end,
})

if can_install then
    install({
        "bash",
        "c",
        "cpp",
        "jsdoc",
        "lua",
        "python",
        "toml",
        "xml",
        "yaml",
        "zsh",
    })
end
