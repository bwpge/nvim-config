local U = require("config.utils")

U.set_config_keymap("fugitive")

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
                    U.set_config_keymap("fugitive_index", { buffer = ev.buf })
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
            preview_config = {
                border = "single",
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(key, dir)
                    local d = dir
                    if dir == "previous" then
                        d = "prev"
                    end

                    U.repeat_nmap(
                        key,
                        function()
                            -- use nvim default behavior in a diff buffer
                            if vim.wo.diff then
                                vim.cmd.normal({ key, bang = true })
                            else
                                gs.nav_hunk(d, { preview = true })
                            end
                        end,
                        "Go to " .. dir .. " hunk",
                        {
                            buffer = bufnr,
                            expr = true,
                        }
                    )
                end

                map("[C", "first")
                map("[c", "previous")
                map("]c", "next")
                map("]C", "last")
                U.set_config_keymap("gitsigns", { buffer = bufnr })
            end,
        },
    },
}
