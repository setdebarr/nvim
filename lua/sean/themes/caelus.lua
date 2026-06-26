-- Theme taken from dacctal
-- https://git.symlinx.net/daccfiles

local M = {}

---@alias Hex string # a "#rrggbb" colour string

-- stylua: ignore start
---@type table<string, Hex>
local colors = {
    bg       = "#0f0f0f",
    gray0    = "#141514",
    gray1    = "#1e1f1e",
    gray2    = "#272a28",
    gray3    = "#3b403c",
    gray4    = "#585f5b",
    gray5    = "#6c756f",
    gray6    = "#888e7b",
    gray7    = "#9a9c8b",
    gray8    = "#b6b69a",
    gray9    = "#d9cdb5",
    gray10   = "#e3d6c9",
    fg       = "#f4decd",
    red      = "#f16e65",
    lred     = "#ef968f",
    orange   = "#ef934d",
    yellow   = "#efbf71",
    green    = "#7ec97e",
    lgreen   = "#a4daa4",
    cyan     = "#7ec9a3",
    lcyan    = "#abd4bf",
    blue     = "#71b4d6",
    lblue    = "#b0d4e8",
    magenta  = "#e28dc6",
    lmagenta = "#ebadd6",
}
-- stylua: ignore end

---@param group string
---@param opts vim.api.keyset.highlight
local function hl(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

function M.colorscheme()
    vim.g.colors_name = nil

    vim.o.termguicolors = true
    vim.o.background = "dark"

    vim.cmd("highlight clear")

    if vim.fn.exists("syntax_on") == 1 then
        vim.cmd("syntax reset")
    end

    vim.g.colors_name = "caelus"

    -- Base UI
    hl("Normal", { fg = colors.fg, bg = colors.bg })
    hl("NormalNC", { fg = colors.fg, bg = colors.bg })
    hl("NormalFloat", { fg = colors.fg, bg = colors.gray1 })
    hl("FloatBorder", { fg = colors.gray6, bg = colors.gray1 })
    hl("FloatTitle", { fg = colors.orange, bg = colors.gray1, bold = true })

    hl("Cursor", { fg = colors.bg, bg = colors.fg })
    hl("CursorLine", { bg = colors.gray2 })
    hl("CursorColumn", { bg = colors.gray1 })
    hl("ColorColumn", { bg = colors.gray1 })

    hl("Visual", { bg = colors.gray3 })
    hl("VisualNOS", { bg = colors.gray3 })

    hl("Search", { fg = colors.bg, bg = colors.orange })
    hl("IncSearch", { fg = colors.bg, bg = colors.yellow })
    hl("CurSearch", { fg = colors.bg, bg = colors.yellow })

    hl("LineNr", { fg = colors.gray6 })
    hl("CursorLineNr", { fg = colors.orange, bold = true })
    hl("SignColumn", { bg = colors.bg })
    hl("FoldColumn", { fg = colors.gray6, bg = colors.bg })
    hl("Folded", { fg = colors.gray8, bg = colors.gray2 })

    hl("WinSeparator", { fg = colors.gray4 })
    hl("VertSplit", { link = "WinSeparator" })

    hl("NonText", { fg = colors.gray4 })
    hl("EndOfBuffer", { fg = colors.bg })
    hl("Whitespace", { fg = colors.gray3 })
    hl("SpecialKey", { fg = colors.gray5 })

    hl("Directory", { fg = colors.blue })
    hl("Title", { fg = colors.orange, bold = true })

    hl("ErrorMsg", { fg = colors.red, bold = true })
    hl("WarningMsg", { fg = colors.yellow, bold = true })
    hl("ModeMsg", { fg = colors.green })
    hl("MoreMsg", { fg = colors.green })
    hl("Question", { fg = colors.green })
    hl("MsgArea", { fg = colors.fg, bg = colors.bg })

    hl("MatchParen", { fg = colors.orange, bold = true })
    hl("Todo", { fg = colors.bg, bg = colors.yellow, bold = true })
    hl("Underlined", { fg = colors.blue, underline = true })

    -- Statusline / tabs
    hl("StatusLine", { fg = colors.fg, bg = colors.gray2 })
    hl("StatusLineNC", { fg = colors.gray7, bg = colors.gray1 })

    hl("TabLine", { fg = colors.gray8, bg = colors.gray1 })
    hl("TabLineSel", { fg = colors.bg, bg = colors.orange, bold = true })
    hl("TabLineFill", { bg = colors.bg })

    hl("WinBar", { fg = colors.fg, bg = colors.bg })
    hl("WinBarNC", { fg = colors.gray7, bg = colors.bg })

    -- Popup menu
    hl("Pmenu", { fg = colors.fg, bg = colors.gray1 })
    hl("PmenuSel", { fg = colors.bg, bg = colors.orange })
    hl("PmenuSbar", { bg = colors.gray2 })
    hl("PmenuThumb", { bg = colors.orange })
    hl("PmenuMatch", { fg = colors.orange, bold = true })
    hl("PmenuMatchSel", { fg = colors.bg, bg = colors.orange, bold = true })

    -- Core syntax
    hl("Comment", { fg = colors.gray8, italic = true })

    hl("Constant", { fg = colors.magenta })
    hl("String", { fg = colors.green })
    hl("Character", { fg = colors.green })
    hl("Number", { fg = colors.magenta })
    hl("Boolean", { fg = colors.magenta })
    hl("Float", { fg = colors.magenta })

    hl("Identifier", { fg = colors.blue })
    hl("Function", { fg = colors.yellow })

    hl("Statement", { fg = colors.red })
    hl("Conditional", { fg = colors.red })
    hl("Repeat", { fg = colors.red })
    hl("Label", { fg = colors.red })
    hl("Operator", { fg = colors.red })
    hl("Keyword", { fg = colors.red })
    hl("Exception", { fg = colors.red })

    hl("PreProc", { fg = colors.magenta })
    hl("Include", { fg = colors.magenta })
    hl("Define", { fg = colors.magenta })
    hl("Macro", { fg = colors.magenta })
    hl("PreCondit", { fg = colors.magenta })

    hl("Type", { fg = colors.cyan, bold = true })
    hl("StorageClass", { fg = colors.cyan })
    hl("Structure", { fg = colors.cyan })
    hl("Typedef", { fg = colors.cyan })

    hl("Special", { fg = colors.yellow })
    hl("SpecialChar", { fg = colors.yellow })
    hl("Tag", { fg = colors.blue })
    hl("Delimiter", { fg = colors.gray8 })
    hl("Debug", { fg = colors.orange })

    hl("Error", { fg = colors.red, bold = true })

    -- Diff
    hl("DiffAdd", { fg = colors.green, bg = colors.gray1 })
    hl("DiffChange", { fg = colors.yellow, bg = colors.gray1 })
    hl("DiffDelete", { fg = colors.red, bg = colors.gray1 })
    hl("DiffText", { fg = colors.orange, bg = colors.gray2 })

    hl("Added", { fg = colors.green })
    hl("Changed", { fg = colors.yellow })
    hl("Removed", { fg = colors.red })

    -- Diagnostics
    hl("DiagnosticError", { fg = colors.red })
    hl("DiagnosticWarn", { fg = colors.yellow })
    hl("DiagnosticInfo", { fg = colors.blue })
    hl("DiagnosticHint", { fg = colors.cyan })
    hl("DiagnosticOk", { fg = colors.green })

    hl("DiagnosticVirtualTextError", { fg = colors.red, bg = colors.gray1 })
    hl("DiagnosticVirtualTextWarn", { fg = colors.yellow, bg = colors.gray1 })
    hl("DiagnosticVirtualTextInfo", { fg = colors.blue, bg = colors.gray1 })
    hl("DiagnosticVirtualTextHint", { fg = colors.cyan, bg = colors.gray1 })
    hl("DiagnosticVirtualTextOk", { fg = colors.green, bg = colors.gray1 })

    hl("DiagnosticUnderlineError", { sp = colors.red, undercurl = true })
    hl("DiagnosticUnderlineWarn", { sp = colors.yellow, undercurl = true })
    hl("DiagnosticUnderlineInfo", { sp = colors.blue, undercurl = true })
    hl("DiagnosticUnderlineHint", { sp = colors.cyan, undercurl = true })
    hl("DiagnosticUnderlineOk", { sp = colors.green, undercurl = true })

    hl("DiagnosticFloatingError", { fg = colors.red })
    hl("DiagnosticFloatingWarn", { fg = colors.yellow })
    hl("DiagnosticFloatingInfo", { fg = colors.blue })
    hl("DiagnosticFloatingHint", { fg = colors.cyan })
    hl("DiagnosticFloatingOk", { fg = colors.green })

    hl("DiagnosticSignError", { fg = colors.red, bg = colors.bg })
    hl("DiagnosticSignWarn", { fg = colors.yellow, bg = colors.bg })
    hl("DiagnosticSignInfo", { fg = colors.blue, bg = colors.bg })
    hl("DiagnosticSignHint", { fg = colors.cyan, bg = colors.bg })
    hl("DiagnosticSignOk", { fg = colors.green, bg = colors.bg })

    -- LSP references
    hl("LspReferenceText", { bg = colors.gray2 })
    hl("LspReferenceRead", { bg = colors.gray2 })
    hl("LspReferenceWrite", { bg = colors.gray2 })

    hl("LspSignatureActiveParameter", { fg = colors.orange, bold = true })

    -- Tree-sitter
    hl("@comment", { link = "Comment" })

    hl("@constant", { link = "Constant" })
    hl("@constant.builtin", { fg = colors.magenta, bold = true })
    hl("@constant.macro", { fg = colors.magenta })

    hl("@string", { link = "String" })
    hl("@string.escape", { fg = colors.yellow })
    hl("@string.special", { fg = colors.yellow })
    hl("@character", { link = "Character" })
    hl("@number", { link = "Number" })
    hl("@boolean", { link = "Boolean" })
    hl("@float", { link = "Float" })

    hl("@variable", { fg = colors.fg })
    hl("@variable.builtin", { fg = colors.red, italic = true })
    hl("@variable.parameter", { fg = colors.lblue })
    hl("@variable.member", { fg = colors.blue })

    hl("@module", { fg = colors.blue })
    hl("@label", { fg = colors.red })

    hl("@function", { link = "Function" })
    hl("@function.builtin", { fg = colors.yellow, bold = true })
    hl("@function.call", { fg = colors.yellow })
    hl("@function.macro", { fg = colors.magenta })
    hl("@method", { fg = colors.yellow })
    hl("@method.call", { fg = colors.yellow })
    hl("@constructor", { fg = colors.cyan })

    hl("@keyword", { link = "Keyword" })
    hl("@keyword.function", { fg = colors.red })
    hl("@keyword.operator", { fg = colors.red })
    hl("@keyword.return", { fg = colors.red })
    hl("@keyword.conditional", { fg = colors.red })
    hl("@keyword.repeat", { fg = colors.red })
    hl("@keyword.exception", { fg = colors.red })

    hl("@operator", { link = "Operator" })

    hl("@type", { link = "Type" })
    hl("@type.builtin", { fg = colors.cyan, bold = true })
    hl("@type.definition", { fg = colors.cyan })
    hl("@attribute", { fg = colors.magenta })
    hl("@property", { fg = colors.blue })

    hl("@punctuation.delimiter", { fg = colors.gray8 })
    hl("@punctuation.bracket", { fg = colors.gray8 })
    hl("@punctuation.special", { fg = colors.yellow })

    hl("@tag", { fg = colors.red })
    hl("@tag.attribute", { fg = colors.yellow })
    hl("@tag.delimiter", { fg = colors.gray8 })

    hl("@markup.heading", { fg = colors.orange, bold = true })
    hl("@markup.strong", { bold = true })
    hl("@markup.italic", { italic = true })
    hl("@markup.link", { fg = colors.blue, underline = true })
    hl("@markup.link.url", { fg = colors.blue, underline = true })
    hl("@markup.raw", { fg = colors.green })
    hl("@markup.list", { fg = colors.orange })

    hl("@diff.plus", { fg = colors.green })
    hl("@diff.minus", { fg = colors.red })
    hl("@diff.delta", { fg = colors.yellow })

    -- LSP semantic tokens
    hl("@lsp.type.namespace", { link = "@module" })
    hl("@lsp.type.type", { link = "@type" })
    hl("@lsp.type.class", { link = "@type" })
    hl("@lsp.type.enum", { link = "@type" })
    hl("@lsp.type.interface", { link = "@type" })
    hl("@lsp.type.struct", { link = "@type" })
    hl("@lsp.type.parameter", { link = "@variable.parameter" })
    hl("@lsp.type.variable", { link = "@variable" })
    hl("@lsp.type.property", { link = "@property" })
    hl("@lsp.type.enumMember", { link = "@constant" })
    hl("@lsp.type.function", { link = "@function" })
    hl("@lsp.type.method", { link = "@method" })
    hl("@lsp.type.macro", { link = "@function.macro" })
    hl("@lsp.type.keyword", { link = "@keyword" })
    hl("@lsp.type.comment", { link = "@comment" })

    -- GitSigns
    hl("GitSignsAdd", { fg = colors.green, bg = colors.bg })
    hl("GitSignsChange", { fg = colors.yellow, bg = colors.bg })
    hl("GitSignsDelete", { fg = colors.red, bg = colors.bg })
    hl("GitSignsAddNr", { fg = colors.green, bg = colors.bg })
    hl("GitSignsChangeNr", { fg = colors.yellow, bg = colors.bg })
    hl("GitSignsDeleteNr", { fg = colors.red, bg = colors.bg })
    hl("GitSignsAddLn", { bg = colors.gray1 })
    hl("GitSignsChangeLn", { bg = colors.gray1 })
    hl("GitSignsDeleteLn", { bg = colors.gray1 })

    -- Telescope
    hl("TelescopeNormal", { fg = colors.fg, bg = colors.gray1 })
    hl("TelescopeBorder", { fg = colors.gray6, bg = colors.gray1 })
    hl("TelescopePromptNormal", { fg = colors.fg, bg = colors.gray2 })
    hl("TelescopePromptBorder", { fg = colors.gray6, bg = colors.gray2 })
    hl("TelescopePromptTitle", { fg = colors.bg, bg = colors.orange, bold = true })
    hl("TelescopePreviewTitle", { fg = colors.bg, bg = colors.green, bold = true })
    hl("TelescopeResultsTitle", { fg = colors.bg, bg = colors.blue, bold = true })
    hl("TelescopeSelection", { fg = colors.orange, bg = colors.gray2, bold = true })
    hl("TelescopeMatching", { fg = colors.orange, bold = true })
end

return M
