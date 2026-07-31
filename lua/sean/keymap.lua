local utils = require("sean.utils")
local map = utils.map
local M = {}

function M.lazygit()
    map("n", "<leader>lg", require("sean.native.lazygit").toggle, { desc = "Open [L]azy[G]it" })
end

function M.native()
    map("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting default register" })

    map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
    map("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

    map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

    map("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })

    map("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })
    map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down half page and center cursor" })
    map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up half page and center cursor" })

    -- better up/down
    map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true })
    map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true })
    map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true })
    map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true })

    -- Move to window using the <ctrl> hjkl keys
    map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
    map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
    map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })
    map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })

    -- terminal
    map("t", "<C-h>", "<cmd>wincmd h<CR>")
    map("t", "<C-j>", "<cmd>wincmd j<CR>")
    map("t", "<C-k>", "<cmd>wincmd k<CR>")
    map("t", "<C-l>", "<cmd>wincmd l<CR>")

    -- Move Lines
    map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
    map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
    map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
    map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
    map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
    map(
        "v",
        "<A-k>",
        ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv",
        { desc = "Move Up" }
    )

    -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
    map("n", "n", "'Nn'[v:searchforward].'zzzv'", { expr = true, desc = "Next Search Result" })
    map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
    map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
    map("n", "N", "'nN'[v:searchforward].'zzzv'", { expr = true, desc = "Prev Search Result" })
    map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
    map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
end

---@param client vim.lsp.Client
---@param bufnr integer
function M.lsp(client, bufnr)
    local opts = { buffer = bufnr }

    if client.name == "clangd" then
        map("n", "<F4>", "<cmd>LspClangdSwitchSourceHeader<cr>", {
            buffer = bufnr,
            desc = "Switch Source/Header",
        })
    end

    opts.desc = "Go to declaration"
    map("n", "gD", vim.lsp.buf.declaration, opts)

    opts.desc = "See available code actions"
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

    opts.desc = "Smart rename"
    map("n", "<leader>rn", vim.lsp.buf.rename, opts)

    opts.desc = "Show line diagnostics"
    map("n", "<leader>ld", vim.diagnostic.open_float, opts)

    opts.desc = "Go to previous diagnostic"
    map("n", "[d", function()
        vim.diagnostic.jump({
            count = -1,
            on_jump = function()
                vim.diagnostic.open_float()
            end,
        })
    end, opts)

    opts.desc = "Go to next diagnostic"
    map("n", "]d", function()
        vim.diagnostic.jump({
            count = 1,
            on_jump = function()
                vim.diagnostic.open_float()
            end,
        })
    end, opts)

    opts.desc = "Hover documentation"
    map("n", "K", vim.lsp.buf.hover, opts)

    opts.desc = "Restart LSP"
    map("n", "<leader>rs", ":lsp restart<CR>", opts)

    if client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
        map("i", "<C-Space>", vim.lsp.completion.get, {
            buffer = bufnr,
            desc = "Trigger completion",
        })
    end
end

---@param bufnr integer
function M.gitsigns(bufnr)
    local gitsigns = require("gitsigns")
    local opts = { buffer = bufnr }

    opts.desc = "Jump to next git [c]hange"
    map("n", "]c", function()
        if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
        else
            gitsigns.nav_hunk("next")
        end
    end, opts)

    opts.desc = "Jump to previous git [c]hange"
    map("n", "[c", function()
        if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
        else
            gitsigns.nav_hunk("prev")
        end
    end, opts)

    opts.desc = "git [s]tage hunk"
    map("v", "<leader>hs", function()
        gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, opts)

    opts.desc = "git [r]eset hunk"
    map("v", "<leader>hr", function()
        gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, opts)

    opts.desc = "git [s]tage hunk"
    map("n", "<leader>hs", gitsigns.stage_hunk, opts)

    opts.desc = "git [r]eset hunk"
    map("n", "<leader>hr", gitsigns.reset_hunk, opts)

    opts.desc = "git [S]tage buffer"
    map("n", "<leader>hS", gitsigns.stage_buffer, opts)

    opts.desc = "git [R]eset buffer"
    map("n", "<leader>hR", gitsigns.reset_buffer, opts)

    opts.desc = "git [p]review hunk"
    map("n", "<leader>hp", gitsigns.preview_hunk, opts)

    opts.desc = "git preview hunk [i]nline"
    map("n", "<leader>hi", gitsigns.preview_hunk_inline, opts)

    opts.desc = "git [b]lame line"
    map("n", "<leader>hb", function()
        gitsigns.blame_line({ full = true })
    end, opts)

    opts.desc = "git [d]iff against index"
    map("n", "<leader>hd", gitsigns.diffthis, opts)

    opts.desc = "git [D]iff against last commit"
    map("n", "<leader>hD", function()
        gitsigns.diffthis("@")
    end, opts)

    opts.desc = "git hunk [Q]uickfix list (all files in repo)"
    map("n", "<leader>hQ", function()
        gitsigns.setqflist("all")
    end, opts)

    opts.desc = "git hunk [q]uickfix list (all changes in this file)"
    map("n", "<leader>hq", gitsigns.setqflist, opts)

    opts.desc = "[T]oggle git show [b]lame line"
    map("n", "<leader>tb", gitsigns.toggle_current_line_blame, opts)

    opts.desc = "[T]oggle git intra-line [w]ord diff"
    map("n", "<leader>tw", gitsigns.toggle_word_diff, opts)

    opts.desc = nil
    map({ "o", "x" }, "ih", gitsigns.select_hunk, opts)
end

---@param actions table
---@return table
function M.telescope_picker_mappings(actions)
    return {
        i = {
            ["<c-d>"] = actions.delete_buffer,
        },
        n = {
            ["<c-d>"] = actions.delete_buffer,
            dd = actions.delete_buffer,
        },
    }
end

function M.telescope()
    local builtin = require("telescope.builtin")

    map("n", "<leader>sn", function()
        require("telescope").extensions.fidget.fidget()
    end, { desc = "Notifications" })
    map("n", "<leader>gl", builtin.git_commits, { desc = "Git Commits" })
    map("n", "<leader>gs", builtin.git_status, { desc = "Git Status" })
    map("n", "<leader><leader>", function()
        builtin.buffers({ sort_mru = true, sort_lastused = true })
    end, { desc = "Switch Buffer" })
    map("n", "<leader>sf", function()
        builtin.find_files({ cwd = utils.get_root() })
    end, { desc = "Search Files (Root Dir)" })
    map("n", "<leader>fr", builtin.oldfiles, { desc = "Recent" })
    map("n", '<leader>s"', builtin.registers, { desc = "Registers" })
    map("n", "<leader>s/", builtin.search_history, { desc = "Search History" })
    map("n", "<leader>sa", builtin.autocommands, { desc = "Auto Commands" })
    map("n", "<leader>sb", builtin.current_buffer_fuzzy_find, { desc = "Buffer Lines" })
    map("n", "<leader>sc", builtin.command_history, { desc = "Command History" })
    map("n", "<leader>sC", builtin.commands, { desc = "Commands" })
    map("n", "<leader>sD", builtin.diagnostics, { desc = "Diagnostics" })
    map("n", "<leader>sd", function()
        builtin.diagnostics({ bufnr = 0 })
    end, { desc = "Buffer Diagnostics" })
    map("n", "<leader>sg", function()
        builtin.live_grep({ cwd = utils.get_root() })
    end, { desc = "Grep (Root Dir)" })
    map("n", "<leader>sh", builtin.help_tags, { desc = "Help Pages" })
    map("n", "<leader>sH", builtin.highlights, { desc = "Search Highlight Groups" })
    map("n", "<leader>sj", builtin.jumplist, { desc = "Jumplist" })
    map("n", "<leader>sk", builtin.keymaps, { desc = "Key Maps" })
    map("n", "<leader>sl", builtin.loclist, { desc = "Location List" })
    map("n", "<leader>sM", builtin.man_pages, { desc = "Man Pages" })
    map("n", "<leader>sm", builtin.marks, { desc = "Jump to Mark" })
    map("n", "<leader>so", builtin.vim_options, { desc = "Options" })
    map("n", "<leader>sR", builtin.resume, { desc = "Resume" })
    map("n", "<leader>sq", builtin.quickfix, { desc = "Quickfix List" })
    map("n", "<leader>sw", function()
        builtin.grep_string({ cwd = utils.get_root(), word_match = "-w" })
    end, { desc = "Word (Root Dir)" })
    map("x", "<leader>sw", function()
        builtin.grep_string({ cwd = utils.get_root(), search = utils.get_visual_selection() })
    end, { desc = "Selection (Root Dir)" })
    map("n", "<leader>uC", function()
        builtin.colorscheme({ enable_preview = true })
    end, { desc = "Colorscheme with Preview" })
    map("n", "<leader>ss", builtin.lsp_document_symbols, { desc = "Goto Symbol" })
    map(
        "n",
        "<leader>sS",
        builtin.lsp_dynamic_workspace_symbols,
        { desc = "Goto Symbol (Workspace)" }
    )
    map("n", "<leader>/", function()
        local filename = vim.api.nvim_buf_get_name(0)
        if filename == "" then
            builtin.current_buffer_fuzzy_find({ previewer = false })
            return
        end
        builtin.live_grep({
            winblend = 10,
            previewer = true,
            search_dirs = { filename },
        })
    end, { desc = "[/] Search in current buffer" })
    map("n", "<leader>//", function()
        builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
    end, { desc = "[//] Search in Open Files" })
    map("n", "gd", function()
        builtin.lsp_definitions({ reuse_win = true })
    end, { desc = "Find Definition" })
    map("n", "gr", builtin.lsp_references, { desc = "References", nowait = true })
    map("n", "gi", function()
        builtin.lsp_implementations({ reuse_win = true })
    end, { desc = "Find Implementation" })
    map("n", "gt", function()
        builtin.lsp_type_definitions({ reuse_win = true })
    end, { desc = "Find Type Definition" })
end

function M.nvim_tree()
    map("n", "<leader>e", "<Cmd>NvimTreeToggle<CR>", { desc = "File Explorer" })
end

function M.typescript_tools()
    map("n", "<A-o>", "<cmd>TSToolsOrganizeImports<CR>", { desc = "Organize Imports" })
end

function M.conform()
    map({ "n", "v" }, "<leader>ff", function()
        require("conform").format({
            lsp_format = "fallback",
            async = false,
            timeout_ms = 1000,
        })
    end, { desc = "Format file or range (in visual mode)" })
end

function M.trouble()
    map("n", "<leader>q", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List" })
    map(
        "n",
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        { desc = "Document Symbols" }
    )
    map(
        "n",
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false<cr>",
        { desc = "LSP Definitions / References" }
    )
end

return M
