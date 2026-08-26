local function lsp_clients()
    local clients = vim.lsp.get_clients({ bufnr = 0 })

    if #clients == 0 then
        return ""
    end

    local names = {}

    for _, client in ipairs(clients) do
        table.insert(names, client.name)
    end

    return "󰒋 " .. table.concat(names, ", ")
end

local config = {
    options = {
        icons_enabled = true,
        theme = "auto",
    },
    sections = {
        lualine_x = {
            lsp_clients,
            "encoding",
            "fileformat",
            "filetype",
        },
    },
}

require("lualine").setup(config)
