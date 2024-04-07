local utils = require("user.utils")

return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    init = function()
        vim.g.loaded_netrwPlugin = 1
        vim.g.loaded_netrw = 1

        -- load neo-tree if starting nvim with a directory
        if vim.fn.argc(-1) == 1 then
            ---@diagnostic disable-next-line: param-type-mismatch
            local stat = vim.uv.fs_stat(vim.fn.argv(0))
            if stat and stat.type == "directory" then
                -- fix colorscheme issues at startup
                vim.schedule(function()
                    require("neo-tree")
                end)
            end
        end
    end,
    opts = utils.merge_custom_opts("neo-tree", {
        close_if_last_window = true,
        open_files_do_not_replace_types = {
            "diff",
            "fugitive",
            "fugitiveblame",
            "Outline",
            "qf",
            "terminal",
            "toggleterm",
            "Trouble",
            "trouble",
        },
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
                ["<Space>"] = "none",
                ["<F2>"] = "rename",
            },
        },
    }),
}
