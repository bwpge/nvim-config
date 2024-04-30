local utils = require("user.utils")
local nmap = utils.nmap

return {
    {
        "tpope/vim-fugitive",
        dependencies = { "tpope/vim-rhubarb" },
        event = "LazyFile",
        cmd = { "G", "Git", "Gdiffsplit", "GBrowse" },
        config = function()
            local function confirm_gp()
                utils.confirm_yn("Push changes to remote?", function()
                    vim.cmd("Git push")
                end)
            end

            -- add keymap in summary buffer
            local group = vim.api.nvim_create_augroup("FugitiveKeymaps", { clear = true })
            vim.api.nvim_create_autocmd({ "User" }, {
                pattern = "FugitiveIndex",
                callback = function(ev)
                    local opts = { buffer = ev.buf }
                    nmap("A", "<cmd>Git add -A<cr>", "Stage all files", opts)
                    nmap("<leader>gp", confirm_gp, "Push changes to remote", opts)
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
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function gs_nav_map(key, dir, desc)
                    nmap(key, function()
                        if vim.wo.diff then
                            vim.cmd.normal({ key, bang = true })
                        else
                            gs.nav_hunk(dir, { preview = true })
                        end
                    end, desc, { buffer = bufnr })
                end
                gs_nav_map("[c", "prev", "Move to previous hunk diff")
                gs_nav_map("]c", "next", "Move to next hunk diff")

                nmap("<leader>hr", gs.reset_hunk, "Reset git hunk")
                nmap("<leader>hh", gs.preview_hunk, "View hunk diff")
                nmap("<leader>hi", gs.preview_hunk_inline, "View inline hunk diff")
                nmap("<leader>hb", gs.blame_line, "View git blame on current line")
            end,
        },
    },
}
