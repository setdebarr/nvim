local sections = {
    mount = "Mount",
    automount = "Automount",
    path = "Path",
    slice = "Slice",
    swap = "Swap",
    scope = "Scope",
}

local unit_directive = vim.regex(
    [[^\s*\%(Wants\|Requires\|BindsTo\|PartOf\|After\|Before\|Conflicts\|Condition[A-Za-z]\+\|Assert[A-Za-z]\+\)\s*=]]
)

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = "filetypedetect",
    pattern = { "*.service", "*.socket", "*.timer" },
    callback = function()
        vim.cmd("setfiletype systemd")
    end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = "filetypedetect",
    pattern = {
        "*.target",
        "*.mount",
        "*.automount",
        "*.path",
        "*.slice",
        "*.swap",
        "*.scope",
        "*.device",
    },
    callback = function()
        if vim.bo.filetype ~= "" then
            return
        end

        local unit_type = vim.fn.expand("%:e")
        local section = ""
        for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
            if line:match("^%s*[#;]") then
                goto continue
            end

            local header = line:match("^%s*%[([A-Za-z]+)%]%s*$")
            if header then
                section = header
                if sections[unit_type] == section then
                    vim.cmd("setfiletype systemd")
                    return
                end
                goto continue
            end

            if
                (unit_type == "target" or unit_type == "device")
                and section == "Unit"
                and unit_directive:match_str(line) ~= nil
            then
                vim.cmd("setfiletype systemd")
                return
            end

            ::continue::
        end
    end,
})
