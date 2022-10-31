local utils = require('user.core.utils')
local autopairs = utils.require_plugin('nvim-autopairs')
if not autopairs then return end

autopairs.setup({
    check_ts = true, -- enable treesitter integration
    ts_config = {
        lua = { 'string' },
        java = false,
        javascript = { 'template_string' },
    },
})

-- cmp integration, not needed so don't print errors
local notify_opts = {
    level = 'warn',
    fmt = 'Could not load \'%s\' for autopairs integration.',
}
local autopairs_cmp = utils.require_plugin('nvim-autopairs.completion.cmp', notify_opts)
if not autopairs_cmp then return end

local cmp = utils.require_plugin('cmp', notify_opts)
if not cmp then return end

cmp.event:on('confirm_done', autopairs_cmp.on_confirm_done())
