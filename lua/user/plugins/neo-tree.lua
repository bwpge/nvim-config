return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    opts = {
        window = { position = "left" },
        filesystem = {
            filtered_items = {
                visible = true, -- when true, they will just be displayed differently than normal items
                hide_dotfiles = false,
                hide_gitignored = true,
                hide_hidden = true, -- only works on Windows for hidden files/directories
                -- hide_by_name = {
                --     ".git",
                -- },
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
        buffers = {
            follow_current_file = {
                enabled = true,
            },
        },
    },
}
