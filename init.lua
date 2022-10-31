-- bootstrapper must be imported first
require('user.setup')

-- core configuration
require('user.core.options')
require('user.core.keymaps')
require('user.core.theme')
require('user.core.autocommands')

-- plugin configurations
require('user.plugins.notify') -- load notify before everything else so we can use it
require('user.plugins.comment')
require('user.plugins.nvim-tree')
require('user.plugins.lualine')
require('user.plugins.telescope')
require('user.plugins.rooter')
require('user.plugins.gitsigns')
require('user.plugins.bufferline')
require('user.plugins.autopairs')
require('user.plugins.fidget')
require('user.plugins.toggleterm')

-- lsp plugins
require('user.plugins.treesitter')
require('user.plugins.mason') -- needs to come before lspconfig
require('user.plugins.lspsaga')
require('user.plugins.lspconfig')
require('user.plugins.nvim-cmp')
