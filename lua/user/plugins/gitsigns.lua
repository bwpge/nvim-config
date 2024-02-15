local utils = require("user.utils")
local nmap = utils.nmap

return {
    {
        "lewis6991/gitsigns.nvim",
        opts = {
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
                nmap("<leader>hr", gs.reset_hunk, "Reset git hunk (discard changes)")
                nmap("<leader>hh", gs.preview_hunk, "Preview git diff hunk")
            end,
        },
    },
}
