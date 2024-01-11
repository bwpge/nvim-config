return {
    {
        'hrsh7th/nvim-cmp',
        event = 'VeryLazy',
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'L3MON4D3/LuaSnip' },
            { 'onsails/lspkind.nvim' },
        },
        config = function()
            local cmp = require('cmp')
            local lspkind = require('lspkind')
            cmp.setup({
                completion = {
                    completeopt = "menu,menuone,preview,noselect",
                },
                formatting = {
                    format = lspkind.cmp_format({
                        mode = 'symbol',
                        ellipsis_char = '…',
                    }),
                },
                mapping = {
                    -- accept completion, must select first
                    ['<cr>'] = cmp.mapping(cmp.mapping.confirm({ select = false }), { 'i', 'c' }),
                    -- show completion menu
                    ['<C-.>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
                    -- close completion menu
                    ['<esc>'] = cmp.mapping(cmp.mapping.abort(), { 'i' }),
                    -- alternate keymap for command mode
                    ['<C-e>'] = cmp.mapping(cmp.mapping.abort(), { 'c' }),
                    ['<up>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
                    ['<down>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
                    ['<C-up>'] = cmp.mapping(cmp.mapping.scroll_docs(-1), { 'i', 'c' }),
                    ['<C-down>'] = cmp.mapping(cmp.mapping.scroll_docs(1), { 'i', 'c' }),
                },
            })
        end
    },
}
