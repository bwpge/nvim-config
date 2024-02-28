local nmap = require("user.utils").nmap

return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        settings = {
            save_on_toggle = true,
            ui_nav_wrap = true,
        },
    },
    config = function(_, opts)
        local harpoon = require("harpoon")
        harpoon:setup(opts)

        nmap("<leader>ha", function()
            harpoon:list():append()
        end)
        nmap("<leader>ht", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end)

        for i = 1, 9, 1 do
            local k = "<leader>" .. i
            local desc = "Select harpoon list item " .. i
            nmap(k, function()
                harpoon:list():select(i)
            end, desc)
        end

        local wrap = { ui_nav_wrap = true }
        nmap("[h", function()
            harpoon:list():prev(wrap)
        end)
        nmap("]h", function()
            harpoon:list():next(wrap)
        end)
    end,
}
