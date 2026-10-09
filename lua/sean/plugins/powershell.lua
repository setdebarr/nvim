---@type powershell.user_config
local config = {
    bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
}

require("powershell").setup(config)
