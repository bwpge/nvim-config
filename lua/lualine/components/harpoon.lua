local utils = require("user.utils")
local lualine_require = require("lualine_require")
local M = lualine_require.require("lualine.component"):extend()

local default_options = {
    icon = "",
    mark_sep = nil,
    max_marks = 9,
    active_hl = "MatchParen",
    fmt_inactive = tostring,
    fmt_active = tostring,
}

function M:init(options)
    M.super.init(self, options)
    self.options = vim.tbl_deep_extend("keep", self.options or {}, default_options)
end

function M:update_status()
    if not package.loaded["harpoon"] then
        return ""
    end

    local hp_list = require("harpoon"):list()
    local total_marks = hp_list.items and #hp_list.items or 0
    if total_marks == 0 then
        return ""
    end

    local max_marks = math.min(total_marks, self.options.max_marks)
    local bufname = vim.fn.expand("%:p")
    local output = {}

    for index = 1, max_marks do
        local mark = vim.fn.fnamemodify(hp_list.items[index].value, ":p")
        if mark == bufname then
            local label = self.options.fmt_active(index)
            table.insert(output, utils.lualine_format_hl(self, label, self.options.active_hl))
        else
            local label = self.options.fmt_inactive(index)
            table.insert(output, label)
        end
    end

    return table.concat(output, self.options.mark_sep or "")
end

return M
