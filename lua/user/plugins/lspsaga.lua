local lspsaga = require('user.core.utils').require_plugin('lspsaga')
if not lspsaga then return end

-- see: https://github.com/glepnir/lspsaga.nvim#configuration
-- for winbar details, see:
--   https://github.com/glepnir/lspsaga.nvim#show-symbols-in-winbarnvim-08-or-in-statusline
lspsaga.init_lsp_saga({
    symbol_in_winbar = { -- enable winbar symbols
        in_custom = true,
        click_support = function(node, clicks, button, modifiers)
            -- To see all avaiable details: vim.pretty_print(node)
            local st = node.range.start
            local en = node.range['end']
            if button == "l" then
                if clicks == 2 then
                    -- double left click to do nothing
                else -- jump to node's starting line+char
                    vim.fn.cursor(st.line + 1, st.character + 1)
                end
            elseif button == "r" then
                if modifiers == "s" then
                    print "lspsaga" -- shift right click to print "lspsaga"
                end -- jump to node's ending line+char
                vim.fn.cursor(en.line + 1, en.character + 1)
            elseif button == "m" then
                -- middle click to visual select node
                vim.fn.cursor(st.line + 1, st.character + 1)
                vim.cmd "normal v"
                vim.fn.cursor(en.line + 1, en.character + 1)
            end
        end
    },
    border_style = 'single',
    saga_winblend = 10,
    move_in_saga = {
        prev = '<up>',
        next = '<down>',
    },
    code_action_keys = {
        exec = '<cr>',
        quit = 'q',
    },
    code_action_lightbulb = {
        enable = true,
        enable_in_insert = true,
        cache_code_action = true,
        sign = true, -- shows lightbulb in sign column
        update_time = 150,
        virtual_text = false, -- shows lightbulb in-line
    },
    finder_action_keys = {
        open = '<cr>',
        quit = { '<esc>', 'q' },
    },
    definition_action_keys = {
        edit = '<cr>',
        quit = '<esc>',
    },
    show_outline = {
        win_position = 'right',
        auto_enter = false,
        auto_preview = true,
        virt_text = '┃',
        jump_key = '<cr>',
        auto_refresh = true, -- not sure if this works
    },
})
