local user_theme = require('user.core.theme').theme_name

local lualine = require('user.core.utils').require_plugin('lualine')
if not lualine then return end

local theme = 'auto'
-- override navarasu/onedark.nvim theme for lualine
if user_theme == 'onedark' then
    theme = require('lualine.themes.onedark') -- use lualine onedark
elseif user_theme == 'onenord' then
    theme = 'onenord' -- use onenord provided theme
end

lualine.setup({
    sections = {
        lualine_c = { 'buffers' }
    },
    extensions = {
        'nvim-tree',
    },

    -- separators for copy-pasting:        
    -- note: the rounded cap doesn't look right with jetbrains mono nf
    options = {
        theme = theme,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
    },
})
