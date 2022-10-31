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

nvimtree.setup({
    -- settings to work with nvim-rooter
    update_cwd = true,
    filters = {
        custom = { '^.git$' }
    },

    -- see: https://github.com/alex-courtis/arch/blob/b5f24e0e7b6554b338e40b3d60f1be437f273023/config/nvim/lua/amc/nvim-tree.lua
    hijack_cursor = true,
    open_on_setup = true,
    open_on_setup_file = true,
    view = {
        signcolumn = "yes",
        adaptive_size = false,
    },
    git = {
        enable = true,
    },
    renderer = {
        special_files = {},
        symlink_destination = false,
        indent_markers = {
            enable = true,
            inline_arrows = true,
            icons = {
                corner = "└",
                edge = "│",
                item = "│",
                bottom = "─",
                none = " ",
            },
        },
        icons = {
            git_placement = "signcolumn",
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
        ignore_list = { "help" },
    },
    diagnostics = {
        enable = true,
        show_on_dirs = true,
    },
})
