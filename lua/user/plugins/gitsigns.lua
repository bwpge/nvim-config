return {
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            on_attach = function()
                local gs = package.loaded.gitsigns
                local function km(key, move, desc)
                    vim.keymap.set("n", key, function()
                        if vim.wo.diff then
                            return key
                        end
                        vim.schedule(function()
                            move()
                        end)
                        return "<Ignore>"
                    end, { noremap = true, silent = true, desc = desc })
                end

                -- move to previous hunk
                km("[h", gs.prev_hunk, "Move to previous hunk")
                -- move to next hunk
                km("]h", gs.next_hunk, "Move to next hunk")
                -- reset hunk
                vim.keymap.set(
                    "n",
                    "<leader>hr",
                    gs.reset_hunk,
                    { noremap = true, silent = true, desc = "Reset hunk (discard changes)" }
                )
                -- preview hunk
                vim.keymap.set(
                    "n",
                    "<leader>hh",
                    gs.preview_hunk,
                    { noremap = true, silent = true, desc = "Preview hunk git diff" }
                )
            end,
        },
    },
}
