local U = require("user.utils")
local nmap = U.nmap

local function harpoon_add()
    local bufname = vim.fn.bufname()
    if not vim.bo.buflisted then
        U.notify_warn("Cannot add hidden buffer `%s` to harpoon", bufname)
        return
    end
    if bufname == "" then
        U.notify_warn("Cannot add no name buffer to harpoon")
    end
    if not vim.fn.filereadable(vim.fn.bufname()) then
        U.notify_warn("Cannot add `%s` to harpoon (does not exist on disk)", bufname)
        return
    end
    require("harpoon"):list():add()
end

local function harpoon_toggle()
    require("harpoon").ui:toggle_quick_menu(require("harpoon"):list(), {
        title = " Harpoon ",
        title_pos = "center",
    })
end

return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    commit = "e76cb03", -- see https://github.com/ThePrimeagen/harpoon/issues/577
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    keys = {
        { "<leader>ha", harpoon_add, desc = "Add current file to harpoon list" },
        { "<leader>ht", harpoon_toggle, desc = "Toggle harpoon quick menu" },
    },
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
            UI_CREATE = function(ctx)
                vim.api.nvim_set_option_value("cursorline", true, { win = ctx.win_id })
                vim.api.nvim_set_option_value(
                    "winhl",
                    U.make_winhl({
                        Normal = "TelescopeNormal",
                        FloatBorder = "TelescopePreviewBorder",
                        FloatTitle = "TelescopePreviewTitle",
                    }),
                    { win = ctx.win_id }
                )
            end,
        })

        for i = 1, 9 do
            local k = "<leader>" .. i
            local desc = "Select harpoon quick menu item " .. i
            nmap(k, function()
                harpoon:list():select(i)
            end, desc)
        end
    end,
}
