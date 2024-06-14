local lualine_require = require("lualine_require")
local U = require("user.utils")
local M = lualine_require.require("lualine.component"):extend()

local default_options = {
    hide_tabline = true,
    min_show = 2,
    show_tab_cwd = true,
    icon = "󰓩 ",
    active_hl = "MatchParen",
    fmt_inactive = tostring,
    fmt_active = tostring,
}

function M:init(options)
    M.super.init(self, options)
    self.options = vim.tbl_deep_extend("keep", self.options or {}, default_options)
    if self.options.hide_tabline then
        vim.opt.showtabline = 0
    end
end

---Returns the working directory for a given tab id.
---@param id integer
---@return string
local function get_tab_cwd(id)
    local cwd = vim.fn.fnamemodify(vim.fn.getcwd(-1, id), ":~"):gsub("\\", "/")
    return cwd
end

---@alias Tab { id: integer, cwd: string, active: boolean }

---Returns a list of tabs with id, working directory, and active flag.
---
---The `cwd` field indicates the active tab's working directory.
---@return { cwd: string, [integer]: Tab }
local function get_tabs()
    local tabs = { cwd = "" }
    local curr_id = vim.fn.tabpagenr()

    for id, _ in ipairs(vim.api.nvim_list_tabpages()) do
        local active = curr_id == id
        local cwd = get_tab_cwd(id)

        if active then
            tabs.cwd = cwd
        end
        table.insert(tabs, { id = id, cwd = cwd, active = active })
    end

    return tabs
end

function M:update_status()
    local tabs = get_tabs()
    if #tabs < self.options.min_show then
        return ""
    end

    local output = {}
    local tab_cwds = {}

    for _, tab in ipairs(tabs) do
        tab_cwds[tab.cwd] = true
        if tab.active then
            local label = self.options.fmt_active(tab.id)
            table.insert(output, U.lualine_format_hl(self, label, self.options.active_hl))
        else
            local label = self.options.fmt_inactive(tab.id)
            table.insert(output, label)
        end
    end

    if self.options.show_tab_cwd then
        -- only show cwd if tabs have different cwds
        local cwds = 0
        for _ in pairs(tab_cwds) do
            cwds = cwds + 1
        end
        if cwds > 1 then
            table.insert(output, " " .. tabs.cwd)
        end
    end

    return table.concat(output, self.options.mark_sep or "")
end

return M
