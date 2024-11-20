local C = require("user.heirline.components")
local styles = require("user.heirline.styles")

local tablist = styles.indicator({
    icon = "󰓩 ",
    items_fn = function()
        local tabs = {}
        local curr_id = vim.fn.tabpagenr()

        for id, _ in ipairs(vim.api.nvim_list_tabpages()) do
            local active = curr_id == id
            table.insert(tabs, { id = id, active = active })
        end

        return tabs
    end,
    is_active = function(tab)
        return tab.active == true
    end,
    color = "blue",
    min_show = 2,
})

local tabcwd = {
    provider = function()
        return vim.fn.fnamemodify(vim.fn.getcwd(-1), ":~:."):gsub("\\", "/")
    end,
}

return {
    C.pad,
    tablist,
    tabcwd,
    C.pad,
}
