local utils = require('user.core.utils')

local cmp = utils.require_plugin('cmp')
if not cmp then return end

local lspkind = utils.require_plugin('lspkind')
if not lspkind then return end

local luasnip = utils.require_plugin('luasnip')
if not luasnip then return end

-- lazy load from_vscode to get only language specific snippets
-- see: https://github.com/L3MON4D3/LuaSnip#add-snippets
require('luasnip.loaders.from_vscode').lazy_load()

local check_backspace = function()
    local col = vim.fn.col '.' - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
end

cmp.setup({
    -- snippets
    snippet = {
        -- snippet engine required by nvim-cmp
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },

    -- on windows terminal, ctrl+space does not send a key to nvim
    mapping = {
        ['<cr>'] = cmp.mapping(cmp.mapping.confirm({ select = false }), { 'i', 'c' }), -- accept completion, must select first
        ['<C-.>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }), -- show completion menu
        ['<esc>'] = cmp.mapping(cmp.mapping.abort(), { 'i' }), -- close completion menu
        ['<C-e>'] = cmp.mapping(cmp.mapping.abort(), { 'c' }), -- alternate keymap for command mode
        ['<up>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
        ['<down>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
        ['<C-up>'] = cmp.mapping(cmp.mapping.scroll_docs(-1), { 'i', 'c' }),
        ['<C-down>'] = cmp.mapping(cmp.mapping.scroll_docs(1), { 'i', 'c' }),
        -- use tab for multiple functions
        ['<tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm({ select = true })
            elseif luasnip.expandable() then
                luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif check_backspace() then
                fallback()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-tab>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },

    -- completion sources
    sources = cmp.config.sources({
        -- order matters for these
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
    }),

    -- experimental features
    experimental = {
        ghost_text = true,
    },

    -- lspkind icons in suggestions
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol',
            maxwidth = 50,
            ellipsis_char = '...',
        })
    },
})

-- Enable completing paths in :
cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
        { name = 'path' }
    })
})
