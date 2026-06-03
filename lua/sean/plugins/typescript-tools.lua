require("typescript-tools").setup({})

local map = require("sean.utils").map

map("n", "<A-o>", "<cmd>TSToolsOrganizeImports<CR>", { desc = "Organize Imports" })
