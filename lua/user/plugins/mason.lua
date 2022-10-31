local utils = require('user.core.utils')

local mason = utils.require_plugin('mason')
if not mason then return end

local mason_lspconfig = utils.require_plugin('mason-lspconfig')
if not mason_lspconfig then return end

mason.setup()
mason_lspconfig.setup({
    ensure_installed = {
        'rust_analyzer',
        'sumneko_lua',
    },
    automatic_installation = true,
})
