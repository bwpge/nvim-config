local U = require("user.utils")
local nmap = U.nmap

local function confirm_push(force)
    return function()
        local prefix = force and "Force push" or "Push"
        U.confirm_yn(prefix .. " changes to remote?", function()
            vim.cmd("Git push" .. (force and " --force" or ""))
        end)
    end
end

nmap("<leader>gs", "<cmd>G<cr>", "Open git status")
nmap("<leader>gd", "<cmd>Gdiffsplit<cr>", "Open current file git diff")
nmap("<leader>gD", "<cmd>Git diff --staged<cr>", "Open git diff for staged files")
nmap("<leader>gb", "<cmd>Git blame<cr>", "Open current file git blame")
nmap("<leader>ga", "<cmd>Git add %<cr>", "Stage current file")
nmap("<leader>gu", "<cmd>Git restore --staged %<cr>", "Unstage current file")
nmap("<leader>gr", "<cmd>Gread<cr>", "Reset current file (discard all changes)")
nmap("<leader>gx", "<cmd>GBrowse<cr>", "Open the current git object in browser at upstream host")

return {
    {
        "tpope/vim-fugitive",
        dependencies = { "tpope/vim-rhubarb" },
        event = "LazyFile",
        cmd = { "G", "Git", "Gdiffsplit", "GBrowse", "Gread" },
        config = function()
            -- add keymaps for summary buffer
            local group = vim.api.nvim_create_augroup("FugitiveKeymaps", { clear = true })
            vim.api.nvim_create_autocmd({ "User" }, {
                pattern = "FugitiveIndex",
                callback = function(ev)
                    local opts = { buffer = ev.buf }
                    nmap("A", "<cmd>Git add -A<cr>", "Stage all files", opts)
                    nmap("<leader>gp", confirm_push(false), "Push changes to remote", opts)
                    nmap("<leader>gP", confirm_push(true), "Force push changes to remote", opts)
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

                local function map(key, dir, desc)
                    nmap(key, function()
                        if vim.wo.diff then
                            vim.cmd.normal({ key, bang = true })
                        else
                            gs.nav_hunk(dir, { preview = true })
                        end
                    end, desc, { buffer = bufnr })
                end
                map("[c", "prev", "Move to previous hunk diff")
                map("]c", "next", "Move to next hunk diff")

                nmap("<leader>hr", gs.reset_hunk, "Reset git hunk")
                nmap("<leader>hh", gs.preview_hunk, "View hunk diff")
                nmap("<leader>hi", gs.preview_hunk_inline, "View inline hunk diff")
                nmap("<leader>hb", gs.blame_line, "View git blame on current line")
            end,
        },
    },
}
