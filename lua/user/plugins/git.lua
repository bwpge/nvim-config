local utils = require("user.utils")
local nmap = utils.nmap

local function git_push_confirm()
    utils.confirm_yn("Push changes to remote?", function()
        vim.cmd("Git push")
    end)
end

return {
    {
        "tpope/vim-fugitive",
        dependencies = { "tpope/vim-rhubarb" },
        event = "LazyFile",
        cmd = { "G", "Git", "Gdiffsplit", "GBrowse" },
        config = function()
            -- add keymap in summary buffer
            local group = vim.api.nvim_create_augroup("FugitiveIndex", { clear = true })
            vim.api.nvim_create_autocmd({ "User" }, {
                pattern = "FugitiveIndex",
                callback = function(ev)
                    nmap(
                        "A",
                        "<cmd>Git add -A<cr>",
                        "Stage all files",
                        { buffer = ev.buf, noremap = true }
                    )
                    nmap(
                        "<Esc>",
                        "<cmd>q<cr>",
                        "Close the status buffer",
                        { buffer = ev.buf, noremap = true }
                    )
                    nmap(
                        "q",
                        "<cmd>q<cr>",
                        "Close the status buffer",
                        { buffer = ev.buf, noremap = true }
                    )
                    nmap(
                        "<leader>gp",
                        git_push_confirm,
                        "Push changes to remote",
                        { buffer = ev.buf, noremap = true }
                    )
                end,
                group = group,
            })
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "LazyFile",
        cmd = "Gitsigns",
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            on_attach = function()
                local gs = package.loaded.gitsigns
                local function gs_map(key, fn, desc)
                    nmap(key, function()
                        if vim.wo.diff then
                            return key
                        end
                        vim.schedule(function()
                            fn({ preview = true })
                        end)
                        return "<Ignore>"
                    end, desc)
                end

                gs_map("[h", gs.prev_hunk, "Move to previous git hunk")
                gs_map("]h", gs.next_hunk, "Move to next git hunk")
                nmap("<leader>hr", gs.reset_hunk, "Reset git hunk")
                nmap("<leader>hh", gs.preview_hunk, "View hunk git diff")
            end,
        },
    },
}
