-- Only apply to real file buffers. LSP hover/float buffers are filetype
-- "markdown" with buftype "nofile"; skip them so spell squiggles and wrap
-- don't leak into hover windows.
if vim.bo.buftype ~= "" then
    return
end

vim.opt_local.wrap = true
vim.opt_local.spell = true
vim.opt_local.spelllang = "en"
