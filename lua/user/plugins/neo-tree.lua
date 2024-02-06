-- avoid flashing netrw before neotree loads
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    lazy = false,
    opts = {
        close_if_last_window = true,
        buffers = {
            follow_current_file = {
                enabled = true,
            },
        },
        default_component_configs = {
            git_status = {
                symbols = { ignored = "" },
            },
        },
        filesystem = {
            filtered_items = {
                visible = true,
                hide_dotfiles = false,
                hide_gitignored = true,
                hide_hidden = true, -- only works on Windows for hidden files/directories
                never_show = {
                    ".DS_Store",
                    "thumbs.db",
                    ".git",
                },
            },
            follow_current_file = {
                enabled = true,
                leave_dirs_open = false,
            },
            group_empty_dirs = true,
            hijack_netrw_behavior = "open_default",
            use_libuv_file_watcher = false,
        },
        window = { position = "left" },
    },
}
