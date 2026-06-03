local config = {
    notification = {
        override_vim_notify = true,
        window = {
            avoid = { "NvimTree" },
        },
    },
}

require("fidget").setup(config)
