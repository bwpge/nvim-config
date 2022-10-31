-- note: NvimTree git status icons don't work in git bash,
--   this is a problem with how vimrun.exe calls shell commands
-- see: https://github.com/neovim/neovim/issues/14605

local nvimtree = require('user.core.utils').require_plugin('nvim-tree')
if not nvimtree then return end

-- TODO: notify that features will not work if running in gitbash

-- disable netrw at start
-- see: https://github.com/nvim-tree/nvim-tree.lua#setup
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- see :h nvim-tree-setup
nvimtree.setup({
    update_cwd = true,
    filters = {
        custom = { '^.git$' }
    },
    hijack_cursor = true,
    open_on_setup = true,
    open_on_setup_file = true,
    view = {
        signcolumn = 'yes',
        adaptive_size = false,
    },
    git = {
        enable = true,
        ignore = false,
        show_on_dirs = false,
        timeout = 400,
    },
    renderer = {
        special_files = {},
        symlink_destination = false,
        highlight_git = true,
        indent_markers = {
            enable = true,
            inline_arrows = true,
            icons = {
                corner = '└',
                edge = '│',
                item = '│',
                bottom = '─',
                none = ' ',
            },
        },
        icons = {
            git_placement = 'signcolumn',
            glyphs = {
                git = {
                    unstaged = '*',
                    staged = '+',
                    unmerged = '',
                    renamed = '➜',
                    untracked = '!',
                    deleted = '✗',
                    ignored = '◌',
                },
            },
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
            },
        },
    },
    update_focused_file = {
        enable = true,
        update_root = true,
        update_cwd = true,
        ignore_list = { 'help' },
    },
    diagnostics = {
        enable = true,
        show_on_dirs = false,
    },
})
