local lualine_require = require("lualine_require")
local M = lualine_require.require("lualine.component"):extend()

local default_options = {
    icon = " ",
    name_sep = ", ",
}

function M:init(options)
    M.super.init(self, options)
    self.options = vim.tbl_deep_extend("keep", self.options or {}, default_options)
end

function M:update_status()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_active_clients({ bufnr = bufnr }) or {}
    if #clients == 0 then
        return ""
    end

    local t = {}
    for _, c in ipairs(clients) do
        table.insert(t, c.name)
    end
    return table.concat(t, self.options.name_sep)
end

return M
