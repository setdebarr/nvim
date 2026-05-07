--@module 'lazy'
---@type LazySpec
return {
    "nvim-telescope/telescope.nvim",

    event = "VimEnter",

    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = function()
                return vim.fn.executable("make") == 1
            end,
        },
        "nvim-telescope/telescope-ui-select.nvim",
        { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },

    config = function()
        local actions = require("telescope.actions")

        local telescope_config = {
            extensions = {
                ["ui-select"] = require("telescope.themes").get_dropdown(),
            },
            pickers = {
                buffers = {
                    initial_mode = "normal",
                    mappings = {
                        i = {
                            ["<c-d>"] = actions.delete_buffer,
                        },
                        n = {
                            ["<c-d>"] = actions.delete_buffer,
                            ["dd"] = actions.delete_buffer,
                        },
                    },
                },
            },
        }

        require("telescope").setup(telescope_config)

        pcall(require("telescope").load_extension, "fzf")
        pcall(require("telescope").load_extension, "ui-select")

        local map = require("utils").map
        local builtin = require("telescope.builtin")

        local function get_root()
            return vim.uv.cwd()
        end

        local function get_visual_selection()
            return table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos(".")), "\n")
        end

        -- git
        map("n", "<leader>gl", builtin.git_commits, { desc = "Git Commits" })
        map("n", "<leader>gs", builtin.git_status, { desc = "Git Status" })

        map("n", "<leader><leader>", function()
            builtin.buffers({ sort_mru = true, sort_lastused = true })
        end, { desc = "Switch Buffer" })

        map("n", "<leader>sf", function()
            builtin.find_files({ cwd = get_root() })
        end, { desc = "Search Files (Root Dir)" })

        map("n", "<leader>fr", builtin.oldfiles, { desc = "Recent" })

        -- search
        map("n", '<leader>s"', builtin.registers, { desc = "Registers" })
        map("n", "<leader>s/", builtin.search_history, { desc = "Search History" })
        map("n", "<leader>sa", builtin.autocommands, { desc = "Auto Commands" })
        map("n", "<leader>sb", builtin.current_buffer_fuzzy_find, { desc = "Buffer Lines" })
        map("n", "<leader>sc", builtin.command_history, { desc = "Command History" })
        map("n", "<leader>sC", builtin.commands, { desc = "Commands" })
        map("n", "<leader>sd", builtin.diagnostics, { desc = "Diagnostics" })

        map("n", "<leader>sD", function()
            builtin.diagnostics({ bufnr = 0 })
        end, { desc = "Buffer Diagnostics" })

        map("n", "<leader>sg", function()
            builtin.live_grep({ cwd = get_root() })
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
            builtin.grep_string({ cwd = get_root(), word_match = "-w" })
        end, { desc = "Word (Root Dir)" })

        map("x", "<leader>sw", function()
            builtin.grep_string({ cwd = get_root(), search = get_visual_selection() })
        end, { desc = "Selection (Root Dir)" })

        map("n", "<leader>uC", function()
            builtin.colorscheme({ enable_preview = true })
        end, { desc = "Colorscheme with Preview" })

        map("n", "<leader>ss", function()
            builtin.lsp_document_symbols()
        end, { desc = "Goto Symbol" })

        map("n", "<leader>sS", function()
            builtin.lsp_dynamic_workspace_symbols()
        end, { desc = "Goto Symbol (Workspace)" })

        map("n", "<leader>/", function()
            builtin.current_buffer_fuzzy_find(
                require("telescope.themes").get_dropdown({ winblend = 10, previewer = false })
            )
        end, { desc = "[/] Fuzzily search in current buffer" })

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
    end,
}
