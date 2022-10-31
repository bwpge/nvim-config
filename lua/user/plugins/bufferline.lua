local bufferline = require('user.core.utils').require_plugin('bufferline')
if not bufferline then return end

bufferline.setup({
    options = {
        mode = 'tabs', -- 'buffers' | 'tabs'
        numbers = 'none',
        close_command = 'Bdelete %d',
        right_mouse_command = nil,
        left_mouse_command = 'buffer %d',
        middle_mouse_command = 'Bdelete %d',
        indicator = {
            icon = '▎', -- this should be omitted if indicator style is not 'icon'
            style = 'icon',
        },
        buffer_close_icon = '',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        max_name_length = 18,
        max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
        truncate_names = true,
        tab_size = 20,
        diagnostics = 'nvim_lsp',
        diagnostics_update_in_insert = false,
        offsets = {
            {
                filetype = 'NvimTree',
                text = '',
                text_align = 'center',
                separator = false,
            },
        },
        color_icons = true, -- whether or not to add the filetype icon highlights
        show_buffer_icons = true, -- disable filetype icons for buffers
        show_buffer_close_icons = true,
        show_buffer_default_icon = true, -- whether or not an unrecognised filetype should show a default icon
        show_close_icon = true,
        show_tab_indicators = false,
        show_duplicate_prefix = false, -- whether to show duplicate buffer prefix
        separator_style = 'slant',
        -- enforce_regular_tabs = false | true,
        always_show_bufferline = true,
        hover = {
            enabled = true,
            delay = 200,
            reveal = { 'close' }
        },
        custom_filter = function(buf_number, _)
            -- filter buffers that are not listed
            return vim.fn.buflisted(buf_number) == 1
        end,
    },
})
