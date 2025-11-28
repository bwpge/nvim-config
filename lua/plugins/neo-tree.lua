-- keep cursor at 0-column in neo-tree explorer
vim.api.nvim_create_autocmd("CursorMoved", {
    pattern = "neo-tree *",
    callback = function(ev)
        if vim.bo[ev.buf].bt ~= "nofile" then
            return
        end
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        if col ~= 0 then
            vim.api.nvim_win_set_cursor(0, { row, 0 })
        end
    end,
})

return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    event = "StartWithDir",
    cmd = "Neotree",
    keys = {
        { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-tree file explorer" },
    },
    opts = {
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
                    unstaged = "○",
                    staged = "●",
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
                ["[c"] = "prev_git_modified",
                ["]c"] = "next_git_modified",
                ["[g"] = false,
                ["]g"] = false,
                ["<F2>"] = "rename",
                ["ga"] = "git_add_file",
                ["gu"] = "git_unstage_file",
            },
        },
    },
}
