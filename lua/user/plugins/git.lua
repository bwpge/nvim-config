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

            local function close()
                ---@diagnostic disable-next-line: param-type-mismatch
                if vim.fn.bufnr("$") == 1 then
                    vim.cmd.quit()
                else
                    vim.cmd.bdelete()
                end
            end

            -- add keymap in summary buffer
            local group = vim.api.nvim_create_augroup("FugitiveKeymaps", { clear = true })
            vim.api.nvim_create_autocmd({ "User" }, {
                pattern = "FugitiveIndex",
                callback = function(ev)
                    local opts = { buffer = ev.buf }
                    nmap("A", "<cmd>Git add -A<cr>", "Stage all files", opts)
                    nmap("q", close, "Close fugitive status buffer", opts)
                    nmap("<leader>gp", confirm_gp, "Push changes to remote", opts)
                end,
                group = group,
            })

            -- add keymap in blame buffer
            vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
                callback = function(ev)
                    if vim.bo[ev.buf].filetype == "fugitiveblame" then
                        local opts = { buffer = ev.buf }
                        nmap("q", close, "Close fugitive blame buffer", opts)
                    end
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

                gs_map("[c", gs.prev_hunk, "Move to previous hunk diff")
                gs_map("]c", gs.next_hunk, "Move to next hunk diff")
                nmap("<leader>hr", gs.reset_hunk, "Reset git hunk")
                nmap("<leader>hh", gs.preview_hunk, "View hunk git diff")
                nmap("<leader>hb", gs.blame_line, "View git blame on current line")
            end,
        },
    },
}
