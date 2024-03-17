return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    init = function()
        vim.g.loaded_netrwPlugin = 1
        vim.g.loaded_netrw = 1
    end,
    lazy = false,
    opts = {
        close_if_last_window = true,
        default_component_configs = {
            git_status = {
                symbols = {
                    -- change type
                    added = "",
                    modified = "",
                    deleted = "✗",
                    renamed = "󰁕",
                    -- status type
                    untracked = "U",
                    ignored = "",
                    unstaged = "󰄱",
                    staged = "󰱒",
                    conflict = "",
                },
            },
            modified = {
                symbol = "",
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
                    "$RECYCLE.BIN",
                    "System Volume Information",
                },
            },
            follow_current_file = {
                enabled = true,
                leave_dirs_open = true,
            },
            group_empty_dirs = true,
            hijack_netrw_behavior = "open_default",
            use_libuv_file_watcher = false,
        },
        window = {
            position = "left",
            mappings = {
                ["<F2>"] = "rename",
            },
        },
    },
}
