local M = {}

-- use this to control theme throughout the rest of config
local theme_name = 'onedark'

local utils = require('user.core.utils')
local theme = utils.require_plugin(theme_name, { notify = false })
if not theme then
    return
end

if theme_name == 'onedark' then
    theme.setup({
        -- choose from: 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
        style = 'dark',
        colors = {
            red = '#e06c75'
        },
        highlights = {
            ['GitSignsChange'] = { fg = '$yellow' },
            ['GitSignsChangeLn'] = { fg = '$yellow' },
            ['GitSignsChangeNr'] = { fg = '$yellow' },
        },
        diagnostics = {
            darker = true, -- darker colors for diagnostic
            undercurl = true, -- use undercurl instead of underline for diagnostics
            background = true, -- use background color for virtual text
        },
    })
end

-- see: https://github.com/rmehri01/onenord.nvim#configuration
if theme_name == 'onenord' then
    theme.setup({
        theme = 'dark',
        borders = true, -- Split window borders
        fade_nc = false, -- Fade non-current windows, making them more distinguishable
        -- Style that is applied to various groups: see `highlight-args` for options
        styles = {
            comments = "italic",
            strings = "NONE",
            keywords = "NONE",
            functions = "NONE",
            variables = "NONE",
            diagnostics = "undercurl",
        },
        disable = {
            background = false, -- Disable setting the background color
            cursorline = false, -- Disable the cursorline
            eob_lines = true, -- Hide the end-of-buffer lines
        },
        -- Inverse highlight for different groups
        inverse = {
            match_paren = false,
        },
        custom_highlights = {}, -- Overwrite default highlight groups
        custom_colors = {}, -- Overwrite default colors
    })
end

-- see: https://github.com/catppuccin/nvim#installation
if theme_name == 'catppuccin' then
    theme.setup({
        -- choose from: 'mocha', 'macchiato', 'frappe', 'latte'
        flavour = 'frappe'
    })
end

-- see: https://github.com/ellisonleao/gruvbox.nvim
if theme_name == 'gruvbox' then
    theme.setup({
        contrast = 'soft',
    })
end

local status, _ = pcall(vim.cmd, 'colorscheme ' .. theme_name)
if not status then
    error('Could not set colorscheme \'' .. theme_name .. '\'!')
    return
end

M.theme_name = theme_name

return M
