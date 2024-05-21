local utils = require("user.utils")
local nmap = utils.nmap

return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    opts = {
        settings = {
            save_on_toggle = true,
        },
    },
    config = function(_, opts)
        local harpoon = require("harpoon")
        harpoon:setup(opts)

        -- style harpoon window
        harpoon:extend({
            UI_CREATE = function(cx)
                vim.api.nvim_set_option_value("cursorline", true, { win = cx.win_id })
                vim.api.nvim_set_option_value(
                    "winhl",
                    utils.make_winhl({
                        Normal = "TelescopeNormal",
                        FloatBorder = "TelescopePreviewBorder",
                        FloatTitle = "TelescopePreviewTitle",
                    }),
                    { win = cx.win_id }
                )
            end,
        })

        nmap("<leader>ha", function()
            harpoon:list():add()
        end)
        nmap("<leader>ht", function()
            harpoon.ui:toggle_quick_menu(harpoon:list(), {
                title = " Harpoon ",
                title_pos = "center",
            })
        end)

        for i = 1, 9 do
            local k = "<leader>" .. i
            local desc = "Select harpoon list item " .. i
            nmap(k, function()
                harpoon:list():select(i)
            end, desc)
        end
    end,
}
