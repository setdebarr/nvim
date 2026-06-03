require("typescript-tools").setup({})

local map = require("utils").map

map("n", "<A-o>", "<cmd>TSToolsOrganizeImports<CR>", { desc = "Organize Imports" })
