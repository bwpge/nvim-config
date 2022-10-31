local treesitter = require('user.core.utils').require_plugin('nvim-treesitter.configs')
if not treesitter then return end

treesitter.setup({
    highlight = {
        enable = true,
        disable = { 'vim' },
    },
    indent = { enable = true },
    ensure_installed = {
        'bash',
        'c',
        'cpp',
        'css',
        -- 'gitignore',
        'html',
        'javascript',
        'json',
        'lua',
        'markdown',
        'python',
        'rust',
        'vim',
        'yaml',
    },
    auto_install = true,
})
