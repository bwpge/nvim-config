local utils = require("user.utils")
local nmap = utils.nmap

return {
    {
        "lewis6991/gitsigns.nvim",
        event = "LazyFile",
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

                gs_map("[g", gs.prev_hunk, "Move to previous git hunk")
                gs_map("]g", gs.next_hunk, "Move to next git hunk")
                nmap("<leader>gr", gs.reset_hunk, "Reset git hunk (discard changes)")
                nmap("<leader>gh", gs.preview_hunk, "Preview git diff hunk")
            end,
        },
    },
}
